####################################################
#
# Script to deploy Carved Rock Fitness PaaS solution
#
####################################################

##############
### Demo 2 ###
##############

### Define Deployment Variables
appNamePrefix='crf'
locations=(
    "eastus"
    "westus"
)

### Create Container Registries
for i in "${locations[@]}"; do
    resourceGroupName="${appNamePrefix}-paas-${i}"
    resourceGroup=$(az group show --name ${resourceGroupName} --output json)
    resourceGroupLocation=$(echo $resourceGroup | jq .location -r)

    acrName="${appNamePrefix}-acr-${resourceGroupLocation}"

    az acr create \
        --resource-group $(echo $resourceGroup | jq .name -r) \
        --name ${acrName} \
        --sku standard \
        --location $(echo $resourceGroup | jq .location -r) \
        --output tsv
done

### Push Image to Container Registries
for i in "${locations[@]}"; do
    resourceGroupName="${appNamePrefix}-paas-${i}"
    resourceGroup=$(az group show --name ${resourceGroupName} --output json)
    resourceGroupLocation=$(echo $resourceGroup | jq .location -r)

    acrName="${appNamePrefix}-acr-${resourceGroupLocation}"
    acr=$(az acr show --name ${acrName} --resource-group ${resourceGroupName} --output json)

    az acr login --name ${acrName} --output tsv
    > docker push myregistry.azurecr.io/samples <
done
