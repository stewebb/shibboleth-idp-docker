# Install Shibboleth Identity Provider by using Docker

## Step 1
Install Docker and docker-compose.

## Step 2
docker compose build

## Step 3
docker compose up -d

## Step 4
Visit http://localhost:8080/idp/profile/SAML2/POST/SSO you should get a webpage with title "Web Login Service - Stale Request"