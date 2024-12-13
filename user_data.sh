#!/bin/bash

# Set hostname
echo "ansible-slave" > /etc/hostname
hostnamectl set-hostname ansible-slave

# Update packages and install dependencies
yum install -y docker

# Start Docker service and enable it on boot
systemctl start docker
systemctl enable docker

# Add a user for Ansible
useradd ansibleadmin
echo "ansibleadmin:s3cret" | chpasswd
usermod -aG docker ansibleadmin

# Allow passwordless sudo for ansibleadmin
echo "ansibleadmin ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set up SSH for ansibleadmin
mkdir -p /home/ansibleadmin/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1/05VqCuHJo39gfZ7454E454HKja2RnxZOXGey+WmkEgJA5CP+IhX0LfD3r1HY4S+xV9aDpmInIVEC8f3Yz0vPasJbUI/q0JWc+1yFcpfQfazNa75PLbb5ygAQ2oVxghvRn9TcKjrZrndeeSgydT11KiEpZdZXNahsMLf1dRoIkrPMxkozegXIc/X9tWcO+S/jp5qc0b25PNO28bh9oPuvnLKIb7Iwwhvbs0UFowgxeWhVlSM657zxepIl+HCRX4O+hon9o7+or8OXpbWBkFj1yoBYG813FwCx6FWRh6wx5jY6Jckmpc511yrw2V5/e3VMCdohDkQnTz2rEnFBu0qMHRWiaGbQ3cOagHEwMOzALrVfCki4pp+RyvNXlpTRE1qHHx3N+lbvWPfzy80z3zj3ZIo8oRyYP8RDxb2DXXr8y8hXq4KxFuuHaEyMG99fgq1cCGV848grY1If4s7bP/EDa9wKmfxOPp9G2Wn5uRzh9ODEBYH/9m20kgvHkvNL90= ansibleadmin@ansible-server" > /home/ansibleadmin/.ssh/authorized_keys
chown -R ansibleadmin:ansibleadmin /home/ansibleadmin/.ssh
chmod 600 /home/ansibleadmin/.ssh/authorized_keys

# Enable password authentication for SSH
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd
