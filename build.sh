if docker build -t rishianand/terraform-executor:local . ; then
    docker push rishianand/terraform-executor:local
else
    echo "build failed"
fi
