<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Thanks again! Now go create something AMAZING! :D
-->
<!-- PROJECT LOGO -->
<br />
<p align="center">
  <h3 align="center">Vagrant kubeadm</h3>
  <p align="center">
    Create a simple kubeadm cluster with vagrant
    <br />
  </p>
</p>

<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

This project creates a 3 node kubernetes cluster using Vagrant and kubeadm. 



<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these steps.

### Prerequisites

* VirtualBox
* Vagrant
* Bash
* Kubectl (to access the cluster)
* Helm (to install the nginx-ingress)
* DNSmasq (to access services via ingress)


### Installation

1. Install all dependencies
2. Clone the repo
   ```sh
   git clone https://github.com/tmill15/vagrant-kubeadm.git
   ```


<!-- USAGE EXAMPLES -->
## Usage

```sh
  run.sh (up|down)
```
Where:
* up: creates a new cluster
* down: destroy the cluster and remove associated files


The cluster configfile will be created at: ~/.kube/config-kubeadm.

To add the configuration to your KUBECONFIG variable, run:
```sh
  export KUBECONFIG=$KUBECONFIG:$HOME/.kube/config-kubeadm
```

## Using the ingress component

To use the ingress component, install dnsmasq on your machine and redirect the local domain to node2 or node3.  
Here's some tutorials to install and configure dnsmasq:

* [MacOS](https://medium.com/@kharysharpe/automatic-local-domains-setting-up-dnsmasq-for-macos-high-sierra-using-homebrew-caf767157e43)
* [Linux](https://www.tecmint.com/setup-a-dns-dhcp-server-using-dnsmasq-on-centos-rhel/)

After the cluster is up, the script will show how to make a redirect, something like this:

```
  To use the ingress component, add this to your dnsmasq configuration:
  address=/.lab/192.168.56.202
```




<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.



<!-- CONTACT -->
## Contact

Thiago Milhomem - [@thiagomilhomem](https://twitter.com/thiagomilhomem) - tmill@outlook.com.br

Project Link: [https://github.com/tmill15/vagrant-kubeadm](https://github.com/tmill15/vagrant-kubeadm)

