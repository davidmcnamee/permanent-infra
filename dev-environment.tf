
resource "google_compute_instance" "dev_server" {
  name         = "dev-server"
  machine_type = "e2-medium"
  zone         = "us-central1-a"
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      size = "60" # Gb
    }
  }
  # network_interface {
  #   network = "default"
  #   access_config {} // Ephemeral public IP
  # }
  metadata = {
    ssh-keys = "davidmcnamee:${file("~/.ssh/id_rsa.pub")}\nroot:${file("~/.ssh/id_rsa.pub")}"
    startup-script = <<-EOF
      #!/bin/bash
      sudo apt update -y
      sudo apt upgrade -y
      sudo apt install gcc docker.io -y
      sudo chmod 666 /var/run/docker.sock
      sudo timedatectl set-timezone America/Toronto
      sudo su - davidmcnamee <<-'HEREDOC'
        echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        brew install jq gh &>> ~/brew-install.log
        echo "${file("gh-access-token.txt")}" > ~/gh-access-token.txt
        gh auth login --with-token < ~/gh-access-token.txt
        echo "StrictHostKeyChecking accept-new" >> ~/.ssh/config
        gh repo list -L 7 --json sshUrl | jq -r ".[] | .sshUrl" | while read repo; do git clone $repo; done
        sudo snap install --classic google-cloud-sdk &>> ~/brew-install.log
        gcloud auth activate-service-account --key-file=$HOME/.config/gcloud/application_default_credentials.json &>> ~/brew-install.log
        echo 'alias gke-creds="gcloud container clusters get-credentials ${google_container_cluster.cluster.name} --region us-central1"' >> ~/.bashrc
        sudo apt install awscli -y &>> ~/brew-install.log
        brew install node yarn python go rustup docker minikube skaffold java bazelisk argocd tree helm terraform &>> ~/brew-install.log
        git config --global pull.rebase true
        git config --global user.name "David McNamee"
        git config --global user.email "d@vidmcnam.ee"
      HEREDOC
    EOF
  }
  tags = ["http-server","https-server"]
  desired_status = "RUNNING"
  can_ip_forward = true
  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.dev_environment_static_ip.address
    }
  }
}
resource "google_compute_address" "dev_environment_static_ip" {
  name = "dev-environment-static-ip"
  region = "us-central1"
}

locals { ip = google_compute_instance.dev_server.network_interface[0].access_config[0].nat_ip }
output "ip" { value = local.ip }

data "external" "copy_ssh_key" {
  program = ["bash", "copy-ssh-key.sh"]
  query = {
    ip = local.ip
  }
}
