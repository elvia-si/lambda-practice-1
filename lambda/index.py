import json
import boto3



def lambda_handler(event, context): 
    s3 = boto3.client("s3")

   # Collect the bucket name from Event
    target_bucket_name = event["S3Bucket"]
    target_key = event["S3Prefix"]

    response = s3.get_object(Bucket=target_bucket_name, Key=target_key)
    data = response["Body"].read()
    json_data = json.loads(data)
    #print(json_data, json_data["pets"][0])
    pets_list = json_data["pets"]

    target_pet_name = event["PetName"]

    for pet in pets_list:
        #print(pet)
        for key in pet:
            print(pet[key])
        # if pet['name'] == target_pet_name:
        #     print("These are" + target_pet_name + target_pet_name["favFoods"])


    


    # RETRIEVE all existing buckets in my account
    my_buckets_raw = s3.list_buckets()
    print(my_buckets_raw)

    # List the name of each bucket
    for b in my_buckets_raw["Buckets"]:
        print("Name of bucket : " + b["Name"])

    # Check if the target bucket exists
    # for b in my_buckets_raw["Buckets"]:
    #     if b["Name"] == target_bucket_name:
    #         print("The bucket " + target_bucket_name + " exists!")   
    


#     return {
#        'status': 'ok'
#    }

  

    



   
