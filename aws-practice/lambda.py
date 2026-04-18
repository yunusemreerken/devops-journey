def lambda_handler(event, context):
    print("Merhaba! Dosya yüklendi!")
    print("Olay (event):", event)
    return {'statusCode': 200, 'body': 'Başarılı'}   