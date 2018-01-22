docker stop test1 && docker rm test1
docker run -d \
	--cpuset-cpus 0-29 \
	--name test1 \
	-v /home/jenkins:/root \
	-v /home/jenkins:/home/jenkins \
       	-p 23:22 \
	zapbranigan/builder-centos1611-make-maven-gcc:latest
