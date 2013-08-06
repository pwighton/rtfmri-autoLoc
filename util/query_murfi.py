#!/usr/bin/python

import math
import socket
import re
import random

class Murfi:
	def __init__(self, ip, port, tr, fake):
		self.IP = ip
		self.PORT = port
		self.TR = tr
		self.FAKE = fake
	
		self.FB_FFA = [float('NaN')] * self.TR
		self.FB_PPA = [float('NaN')] * self.TR
		self.ffa_query = '<?xml version="1.0" encoding="UTF-8"?><info><get dataid=":*:*:*:__TR__:*:*:roi-weightedave:ffa:"></get></info>\n'
		self.ppa_query = '<?xml version="1.0" encoding="UTF-8"?><info><get dataid=":*:*:*:__TR__:*:*:roi-weightedave:ppa:"></get></info>\n'
	
	def sendQ(self, Q):
		if not self.FAKE:		
			s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
			s.connect((self.IP, self.PORT))
			s.send(Q)
			A = s.recv(1024)
			s.close()
			print A
			return A
		else:
			return str(random.gauss(0,1))

	def stripA(self, A):	
		Astrip = re.sub("<.*?>","",A)
		#print "Astrip: ", Astrip
		try:
			stripped = float(Astrip)
		except ValueError:
			stripped = float('nan')
		#print "Stripped is returning: ", stripped
		return stripped

	# These are 1-indexed (like murfi)
	def Q_ffa(self, tr):
		if tr>self.TR:
			print "Q_ffa(self, tr): ERROR: TR Out of BOunds"
			return		
		thisQ = self.ffa_query.replace('__TR__', str(tr))				
		A = self.sendQ(thisQ)
		self.FB_FFA[tr-1] = self.stripA(A)		
	
	# These are 1-indexed (like murfi)	
	def Q_ppa(self, tr):
		if tr>self.TR:
			print "Q_ppa(self, tr): ERROR: TR Out of BOunds"
			return	
		thisQ = self.ppa_query.replace('__TR__', str(tr))
		A = self.sendQ(thisQ)	
		self.FB_PPA[tr-1] = self.stripA(A)

	def update(self):
		#print "UPDATE START"
		ffa_tr = self.TR-1
		for ii in range(0, self.TR-1):
			print "ii:",  ii
			if math.isnan(self.FB_FFA[ii]):
				ffa_tr = ii
				break
		
		ppa_tr = self.TR-1
		for ii in range(0, self.TR-1):
			print "ii:",  ii
			if math.isnan(self.FB_PPA[ii]):
				ppa_tr = ii
				break

		#print "ffa_tr:", ffa_tr
		#print "ppa_tr:", ppa_tr
		
		for ii in range(ffa_tr, self.TR-1):
			#print "Q_ffa:", ii			
			self.Q_ffa(ii+1)
			if math.isnan(self.FB_FFA[ii]):
				break

		for ii in range(ppa_tr, self.TR-1):
			self.Q_ppa(ii+1)
			if math.isnan(self.FB_PPA[ii]):
				break
		return

