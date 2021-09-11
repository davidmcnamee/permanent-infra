
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
  network_interface {
    network = "default"
    access_config {} // Ephemeral public IP
  }
  metadata = {
    ssh-keys = "davidmcnamee:${file("~/.ssh/id_rsa.pub")}\nroot:${file("~/.ssh/id_rsa.pub")}"
  }

  metadata_startup_script = <<-EOF
      #!/bin/bash
      sudo apt update -y
      sudo apt upgrade -y
      sudo apt install gcc docker.io -y
      sudo chmod 666 /var/run/docker.sock
      sudo su - davidmcnamee <<-'HEREDOC'
        echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.profile
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        brew install node yarn python gh go rustup docker minikube java bazelisk argocd tree helm terraform > ~/brew-install.log
        echo "${file("gh-access-token.txt")}" > ~/gh-access-token.txt
        gh auth login --with-token < ~/gh-access-token.txt
        echo "StrictHostKeyChecking accept-new" >> ~/.ssh/config
        gh repo list -L 7 --json sshUrl | jq -r ".[] | .sshUrl" | while read repo; do git clone $repo; done
        git config --global pull.rebase true
        git config --global user.name "David McNamee"
        git config --global user.email "d@vidmcnam.ee"
      HEREDOC
  EOF
}

data "external" "copy_ssh_key" {
  program = ["bash", "copy-ssh-key.sh"]
  query = {
    ip = google_compute_instance.dev_server.network_interface[0].access_config[0].nat_ip
  }
}

output "ip" { value = google_compute_instance.dev_server.network_interface[0].access_config[0].nat_ip }
