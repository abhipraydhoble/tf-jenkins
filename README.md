# tf-jenkins

### Install jenkins 
````
sudo apt update
sudo apt install fontconfig openjdk-21-jre -y
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install jenkins -y
````

### Install terraform
````
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform -y
````

---

### Install following plugins
````
terraform
stage view
aws credentials
````

### manage jenkins >> tools
**terraform** = terraform

### manage jenkins >> credentials 
kind: aws credentaials


---
<img width="1917" height="667" alt="image" src="https://github.com/user-attachments/assets/7e1c1b9f-8524-45b7-92c2-554a0e31dd5a" />


```groovy
pipeline {
    agent any 
    
    tools {
        terraform 'terraform'
    }
    
    stages{
        stage('code-pull'){
            steps {
                git branch: 'main', url: 'https://github.com/abhipraydhoble/tf-jenkins.git'
            }
        }
        
        stage('init'){
            steps {
              withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-cred', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {       
                  sh 'terraform init'
              }
            }
        }
        stage('fmt'){
            steps {
              withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-cred', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {       
                  sh 'terraform fmt'
              }
            }
        }
        
        stage('validate'){
            steps {
              withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-cred', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {       
                  sh 'terraform validate'
              }
            }
        }
        stage('plan'){
            steps {
              withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-cred', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {       
                  sh 'terraform plan'
              }
            }
        }
        stage('apply'){
            steps {
              withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-cred', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {       
                  sh 'terraform $action -auto-approve'
              }
            }
        }
        stage('destroy'){
            steps {
              withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-cred', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {       
                  sh 'terraform $action -auto-approve'
              }
            }
        }
    }
}
```

---

<img width="1917" height="501" alt="image" src="https://github.com/user-attachments/assets/3905d0a4-e896-43f8-9388-ef290f5a19db" />
