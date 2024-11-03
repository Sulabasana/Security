# import uuid

# mac_address = uuid.getnode()
# # To display as hex
# mac_address_hex = ':'.join(['{:02x}'.format((mac_address >> elements) & 0xff) for elements in range(0,8*6,8)][::-1])
# print(mac_address_hex)

# # import the essential modules
# from uuid import getnode as get_mac
# # get the mac address
# mac=get_mac()
# # print the mac address
# print("the mac address is:",mac)
# # covert it into hexa format
# print(hex(mac))
# # reduce the complexity
# # macstring performs the clearest form of mac address and it is the correct form of valid address
# # here the for loop arranges the valid mac address in orderly formats
# macString=':'.join(("%012X" % mac) [i:i+2] for i in range(0,12,2))
# # now print the valid mac address in the correct format
# print('[' + macString + ']')


# For different device in the same network\

import subprocess

def get_mac_address(ip_address):
    arp_command = ['arp', '-n', ip_address]
    output = subprocess.check_output(arp_command).decode()
    mac_address = output.split()[3]
    return mac_address

mac_address = get_mac_address('192.168.1.22')
print(mac_address)