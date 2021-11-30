import os
import json
import logging
import boto3

# s3 = boto3.resource('s3',
#                        aws_access_key_id=os.environ['MY_AWS_KEY_ID'],
#                        aws_secret_access_key=os.environ['MY_AWS_SECRET_ACCESS_KEY']
#                      )

s3 = boto3.resource("s3")


logger = logging.getLogger()
logger.setLevel(logging.INFO)


bucketlist = []
for bucket in s3.buckets.all():
         bucketlist.append(bucket.name)
         print(bucketlist)

def handler(event, context): 
 
    #   for obj in bucketlist.objects.all():
    #     print(obj.key)
    # data = s3.get_object(Bucket='my_s3_bucket', Key='main.txt')
    # contents = data['Body'].read()
    # print(contents)
 
    pet_name = ''

    # retrieve bucket name and file_key from the S3 event
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    file_key = event['Records'][0]['s3']['object']['key']
    logger.info('Reading {} from {}'.format(file_key, bucket_name))
    # get the object
    obj = s3.get_object(Bucket=bucket_name, Key=file_key)
    # read the object
    data = obj.get()['Body'].read().decode('utf-8')
    json_data = json.loads(data)
    #lines = obj['Body'].read().split(b'\n')
    for item in json_data:
       logger.info(item.decode())
       pet_name = item.name
    logger.info(pet_name)

    return {
       'status': 'ok'
   }




   
