#!/bin/bash


do_up(){
    #vagrant up
    if ( ! vagrant box list | grep bento/ubuntu-20.04 > /dev/null ); then
        vagrant box add bento/ubuntu-20.04 --provider virtualbox
    else
        vagrant box update
    fi
    
    vagrant status | awk 'BEGIN{ tog=0; } /^$/{ tog=!tog; } /./ { if(tog){print $1} }' | xargs -P3 -I {} vagrant up {}

    node1_ip=$(vagrant ssh node1 -- hostname -I | awk '{ print $2}')
    vagrant ssh node1 -- sudo kubeadm init --pod-network-cidr=10.100.0.0/16 --apiserver-cert-extra-sans "$node1_ip" --apiserver-advertise-address "$node1_ip" --node-name node1 
    #| tee join.txt
    #join_cmd=$(sed -ne "/kubeadm join/,$ p" join.txt | tr '\n' ' ' | sed 's/\\//g')
    join_cmd=$(vagrant ssh node1 -- sudo kubeadm token create --print-join-command)

    vagrant ssh node2 -- "sudo $join_cmd"
    vagrant ssh node3 -- "sudo $join_cmd" 

    [[ -d ~/.kube ]] || mkdir ~/.kube
    vagrant ssh node1 -- sudo cat /etc/kubernetes/admin.conf > ~/.kube/config-kubeadm
    export KUBECONFIG=$KUBECONFIG:$HOME/.kube/config-kubeadm
    kubectl --context kubernetes-admin@kubernetes create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
    curl -fsSL https://docs.projectcalico.org/manifests/custom-resources.yaml | sed 's/192.168.0.0/10.100.0.0/g' | kubectl --context kubernetes-admin@kubernetes create -f -

    kubectl --context kubernetes-admin@kubernetes create namespace ingress
    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    helm repo update
    helm --kube-context kubernetes-admin@kubernetes -n ingress install ingress ingress-nginx/ingress-nginx --set controller.kind=DaemonSet --set controller.hostNetwork=true 
     
    printf '\n\n\n'
    echo "To add the configuration to your KUBECONFIG variable, run:"
    echo 'export KUBECONFIG=$KUBECONFIG:$HOME/.kube/config-kubeadm'
    printf '\n\n\n'

    node2_ip=$(vagrant ssh node2 -- hostname -I | awk '{ print $2}')
    echo "To use the ingress component, add this to your dnsmasq configuration:"
    echo "address=/.<domain of your choice>/$node2_ip"
}

do_down (){
    echo -n "This will destroy the cluster. Are you sure? (y/n): "
    while  true; do
        read -r ans
        if [ "$ans" = "y" ]; then
            break
        elif [ "$ans" = "n" ]; then
            exit 0
        else
            echo -n "Please type (y/n): " 
        fi
        
    done
    vagrant destroy -f
    rm -f ~/.kube/config-kubeadm
    
}

case "$1" in
    up)
        do_up
    ;;
    down)
        do_down
    ;;
    *)
        echo "$0: (up|down)"
    ;;
esac
