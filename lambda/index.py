import json
import logging
import boto3
import urllib.parse




logger = logging.getLogger()
logger.setLevel(logging.INFO)


# bucketlist = []
# for bucket in s3.buckets.all():
#          bucketlist.append(bucket.name)
#          print(bucketlist)

def lambda_handler(event, context): 
    s3 = boto3.client("s3")

   # Collect the bucket name from Event
    target_bucket_name = event['Records'][0]['s3']['bucket']['name']

    # RETRIEVE all existing buckets in my account
    my_buckets_raw = s3.list_buckets()

    # List the name of each bucket
    for b in my_buckets_raw["Buckets"]:
        print("Name of bucket : " + b["Name"])

    # Check if the target bucket exists
    for b in my_buckets_raw["Buckets"]:
        if b["Name"] == target_bucket_name:
            print("The bucket " + target_bucket_name + " exists!")   


    # data = s3.get_object(Bucket='my_s3_bucket', Key='main.txt')
    # contents = data['Body'].read()
    # print(contents)
 
    pet_name = ''

    # retrieve bucket name and file_key from the S3 event
    # for record in event['Records']:
    #     bucket_name = record[0]['s3']['bucket']['name']
    #     file_key = record[0]['s3']['object']['key']
    #     response = s3.head_object(Bucket=bucket_name, Key=file_key)
    #     print(response)

#     bucket_name = event['Records'][0]['s3']['bucket']['name']
#     file_key = event['Records'][0]['s3']['object']['key']
    
#     logger.info('Reading {} from {}'.format(file_key, bucket_name))
#     # get the object
#     obj = s3.get_object(Bucket=bucket_name, Key=file_key)
#     # read the object
#     data = obj.get()['Body'].read().decode('utf-8')
#     json_data = json.loads(data)
#     #lines = obj['Body'].read().split(b'\n')
#     for item in json_data:
#        logger.info(item.decode())
#        pet_name = item.name
#     logger.info(pet_name)

#     return {
#        'status': 'ok'
#    }

  

    



   
