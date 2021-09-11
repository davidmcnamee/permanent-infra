

resource "google_compute_instance" "dev_server" {
  name         = "davidmcnamee-dev-server"
  machine_type = "e2-medium"
  zone         = "us-central1-a"
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    ssh-keys = "davidmcnamee:${file("~/.ssh/id_rsa.pub")}\nroot:${file("~/.ssh/id_rsa.pub")}"
  }

  metadata_startup_script = <<EOF
      #!/bin/bash
      sudo apt update -y
      sudo apt upgrade -y
      sudo su - davidmcnamee << HEREDOC
        echo helloworld
        whoami
        export HOME=/home/davidmcnamee
        echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/davidmcnamee/.profile
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        brew install gcc yarn python gh
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
