node 
  {	  	          
	  stage ('Workspace Cleanup') {
	  cleanWs()	         
                 
	  }
	  stage('Code Checkout')
	  {
		  git url: 'https://github.com/knagu/WeatherApi.git'
	  }	  
          stage('Build Stage')
	  {	   	  
      sh label: '', script: '''
        cd weatherapi
        dotnet restore
        dotnet build
        dotnet publish -c Release -o out'''
	  echo "Build Successful"
	  }             
      stage('Push Image to DockerHub'){
          withCredentials( [usernamePassword( credentialsId: 'docker', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]){
                                              
                
                sh label: '', script: '''   
                docker build -t knagu/weatherapi:$BUILD_NUMBER .
                docker build -t knagu/weatherapi:latest .
                docker login --username $USERNAME --password $PASSWORD
                docker push knagu/weatherapi:$BUILD_NUMBER
                docker push knagu/weatherapi:latest'''
          }
     }
     stage('Terraform Plan'){                             
                sh label: '', script: '''   
                cd terraform
                terraform init
                echo "yes" | terraform plan                
                '''
          
     }  
      stage('Terraform Apply'){     

    timeout(time: 10, unit: 'MINUTES') {
        input message: "Do you want to proceed for deployment?"
    }                   
                sh label: '', script: '''   
                cd terraform
                echo "yes" | terraform apply
                '''
          
     }               
  }