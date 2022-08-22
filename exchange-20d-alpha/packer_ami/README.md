# Automate deployment of Exchange app to EC2 hosts (Packer)
This repository includes the following:
- Guide how to install packer on your local machine
- How to create custom image for web and api tiers with packer tool
- Systemd daemon process 

# Packer:
- Is an open-source tool made by Hashicorp (made by the same company as Terraform) to create custom images across various platforms(aws, azure, gcp, vmware, docker, vagrant, openstack). 
- Configuration files are written in json format.
- It basically creates ready-to-use images with the Operating System and some extra software ready to use for your applications

## Installation
If you have Homebrew, just type ```brew install packer``` to install it.

For other OS use the following link:
```https://learn.hashicorp.com/tutorials/packer/get-started-install-cli```

## Packer components:

- **builders**
  - Builders are responsible for creating machines and generating images from them for various platforms. For example, there are separate builders for Amazon EC2, Alicloud ECS, Azure, Google Cloud, VMware, VirtualBox, etc.

```
{
  "builders": [
    {
      "ami_name": "ami_name-version",
      "source_ami": "ami_id",
      "instance_type": "t2.micro",
    }
  ]
```
  - Includes required fields in builders.

- **provisioners**
  - Provisioners use builtin and third-party software to install and configure the machine image after booting. Provisioners prepare the system for use, so common use cases for provisioners include:

    - installing packages
    - patching the kernel
    - creating users
    - downloading application code
  
```
"provisioners": [
    {
      "type": "file",
      "source": "../../web",
      "destination": "/home/ec2-user"
    },
    {
      "type": "file",
      "source": "install/install.sh",
      "destination": "/home/ec2-user/install.sh"
    },
    {
      "type": "file",
      "source": "systemd/exchange-web.service",
      "destination": "/tmp/exchange-web.service"
    },
    {
      "type": "shell",
      "inline": [
        "sudo cp /tmp/myservice.service /etc/systemd/system/exchange-web.service"
      ]
    },
    {
      "type": "shell",
      "script": "bootstrap.sh"
    }
  ]
}
```

- **post-processors**
  - Post-processors run after the image is built by the builder and provisioned by the provisioner(s). Post-processors are optional, and they can be used to upload artifacts, re-package, or more.
  
# Custom Image features

- install.sh script installs node.js, installs the node packages for the web/api tier with ```npm install``` command, and starts systemd daemon exchange_web.service
- Copies web/api folder that contains package.json file with dependencies.
- Systemd daemon starts app

# Build image with packer

- cd into ami_for_api
- cd into ami_for_web

```packer build -var-file=variable.json ami.json```

# Issues/Troubleshooting

- I was able to successfully assume role to our dev cluster, but when I run ```packer build``` it still created AMI in my own account, because before I hardcoded access_key and secret_key. If you want packer to biuld image in 312-bc-org account - assume role in your terminal and do not provide access_key and secret_key in packer files.
- Also, I stucked with ```npm install``` command. It worked when I typed it manually in ec2, but when I tried to install it through systemd daemon it failed with this error ```/usr/bin/env: node: No such file or directory```. npm was installed for a specific user but not globally in /usr/bin/ directory. The problem was with node.js installation which I found in AWS documentation. Lately I installed it through yum instead of nvm.

# Helpful Links:

## Packer

[Packer official documentation](https://www.packer.io/docs)

[YouTube tutorial by Sanjeev Thiyagarajan](https://www.youtube.com/watch?v=tbv1lTF1wFU&list=PL8VzFQ8k4U1Jp6eWgHSXHiiRWRvPyCKRj)

## Install nodejs

[Install node packages](https://tecadmin.net/install-latest-nodejs-amazon-linux/)

## Create systemd daemon

[Create a systemd daemon](https://tuttlem.github.io/2018/02/03/create-a-systemd-daemon.html)

[How to create a Systemd service in Linux](https://www.shubhamdipt.com/blog/how-to-create-a-systemd-service-in-linux/)

[Creating systemd Service Files YouTube tutorial](https://www.youtube.com/watch?v=fYQBvjYQ63U&t=301s)
