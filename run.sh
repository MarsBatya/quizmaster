

docker-compose --file=docker-compose-run-built-locally.yml down

echo "http://localhost:8080"

docker-compose --progress=plain --file=docker-compose-run-built-locally.yml up
