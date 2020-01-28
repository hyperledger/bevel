import time
import sys
import logging
import json
import requests
import scanner

logging.basicConfig(filename='scanner.log', level=logging.INFO)
logger = logging.getLogger(__name__)

user_timeout = 3
user= sys.argv[1]

def getTrackingID():
    qrcode = scanner.scan()
    logger.info('retrieved qr code: %s', str(qrcode))
    dump = json.dumps(qrcode)
    load = json.loads(dump)
    index = (load.find('trackingID') + 13)
    return(load[index:index+36])
    

def claimOwnership(trackingID):
    response = requests.put("https://" + user +"api.blockchaincloudpoc.com/api/v1/container/" + trackingID + "/custodian")
    return

def scan():
    while True:
        trackingID = getTrackingID()
        print('trackingID:' + trackingID)
        try:
            claimOwnership(trackingID)
        except:
            print ("An error occured")
        #response = performStep(goodId)
        #logger.info('perform step for %s : %s', str(goodId), str(response))
        time.sleep(user_timeout)


if __name__ == "__main__":
    scan()
