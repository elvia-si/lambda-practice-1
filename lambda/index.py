import json
import boto3



def lambda_handler(event, context): 
    s3 = boto3.client("s3")

    # GET all existing buckets in my account
    my_buckets = s3.list_buckets()
    print(my_buckets)

   # Collect bucket name and obj key from Event
    target_bucket_name = event["S3Bucket"]
    target_key = event["S3Prefix"]

    # GET The object and READ it
    response = s3.get_object(Bucket=target_bucket_name, Key=target_key)
    data = response["Body"].read()
    json_data = json.loads(data)
    pets_list = json_data["pets"]

    target_pet_name = event["PetName"]

    #print the selected Pet favourite food
    for pet in pets_list:
        if pet["name"] == target_pet_name:
            print(pet["favFoods"])

    # List the name of each bucket
    # for b in my_buckets["Buckets"]:
    #     print("Name of bucket : " + b["Name"])

    # Check if the target bucket exists
    # for b in my_buckets_raw["Buckets"]:
    #     if b["Name"] == target_bucket_name:
    #         print("The bucket " + target_bucket_name + " exists!")   
    

  

    



   
