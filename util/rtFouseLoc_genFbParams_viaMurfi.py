#!/usr/bin/python

from query_murfi import Murfi

murfi_IP = '127.0.0.1'
murfi_PORT = 15001
murfi_TR = 184

murfi_FAKE = False
#murfi_FAKE = True

murfi = Murfi(murfi_IP, murfi_PORT, murfi_TR, murfi_FAKE)
murfi.update()
print murfi.FB_FFA
print murfi.FB_PPA



print murfi.FB_FFA
print murfi.FB_PPA 
