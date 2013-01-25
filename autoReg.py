#!/usr/bin/python

import sys, os, errno, glob, subprocess, shutil, datetime, re
from optparse import OptionParser
import xml.etree.ElementTree as ET

# -------- Global Variables ----------
config = None
subject = {}
# ------------------------------------

# Setup and parse command line options
def getOptions():
	parser = OptionParser()
	parser.add_option("-f", "--file", dest="file",
                          help="Location of xml file which stores AutoReg's instructions (REQUIRED)",
                          metavar="FILE")
	parser.add_option("-s", "--subjectname", dest="name",
                          help="The subject's name (default: date+timestamp",
                          metavar="FILE")

	parser.add_option("-c", "--config", dest="configfile", default="./config.xml", 
                          help="Location of xml file which stores system config params (default: ./config.xml)", 
                          metavar="FILE")
 
	parser.add_option("-i", "--init-only", dest="initonly", action="store_true", default=False, 
                          help="Only initialize the directory structure")

	(options, args) = parser.parse_args()

 	# Make sure the instruction file has been defined
	if (options.file == None):
		print " !!! Must define an instruction file"
		print
		parser.print_help()
		sys.exit(0)

	global subject
	if (options.name == None):
		subject['name'] = datetime.datetime.now().strftime('%Y%m%d--%H%M%S')
		print "  !!-> Subject name undefined, using ", subject['name']
	else:
		subject['name'] = options.name
		print "  ---> Subject name is ", subject['name']

	# Parse config file and make the results available globally
	global config
	config = ET.parse(options.configfile).getroot()	
	#print config.find('base_dir').text

	return options

# Initialize subject name global variable and create directory structure
def initSubject(xml):
	global subject

	#subject['name'] = xml.get('subject')

	subject_dir = config.find('subject_dir').text
	subject['subject_dir'] = os.path.join(subject_dir , subject['name'])
	subject['autoreg_data_dir'] = os.path.join(subject_dir, subject['name'], config.find('autoreg_data_dir').text)
	subject['log_dir'] = os.path.join(subject_dir, subject['name'], config.find('log_dir').text)
	subject['additional_dir'] = os.path.join(subject_dir, subject['name'], config.find('additional_dir').text)
	subject['murfi_config_dir'] = os.path.join(subject_dir, subject['name'], config.find('murfi_config_dir').text)
	subject['feat_config_dir'] = os.path.join(subject_dir, subject['name'], config.find('feat_config_dir').text)
	subject['feat_data_dir'] = os.path.join(subject_dir, subject['name'], config.find('feat_data_dir').text)
	subject['murfi_data_dir'] = os.path.join(subject_dir, subject['name'], config.find('murfi_data_dir').text)

	try:
		print "  ---> Creating directory: ", subject['subject_dir']
		os.mkdir(subject['subject_dir'])
		
		print "  ---> Creating directory: ", subject['autoreg_data_dir']
		os.mkdir(subject['autoreg_data_dir'])

		print "  ---> Creating directory: ", subject['log_dir']
		os.mkdir(subject['log_dir'])

		print "  ---> Creating directory: ", subject['additional_dir']
		os.mkdir(subject['additional_dir'])

		print "  ---> Creating directory: ", subject['murfi_config_dir']
		os.mkdir(subject['murfi_config_dir'])

		print "  ---> Creating directory: ", subject['feat_config_dir']
		os.mkdir(subject['feat_config_dir'])

		print "  ---> Creating directory: ", subject['feat_data_dir']
		os.mkdir(subject['feat_data_dir'])

		print "  ---> Creating directory: ", subject['murfi_data_dir']
		os.mkdir(subject['murfi_data_dir'])

		for murfi_subdir in config.find('murfi_data_subdirs').text.split(" "):
			tmpdir = subject['murfi_data_dir'] + "/" + murfi_subdir
			print "  ---> Creating directory: ", tmpdir
			os.mkdir(tmpdir)
		
	except OSError as exc:
		if exc.errno == errno.EEXIST:
			print "  !!-> Directory already exists; aborting rest of directory creation"
			pass
		else: raise

# Parses an xml element and returns the full path based on type:
#   autoreg:    looks for the file in the subject's <autoreg_data_dir> (defined in config.xml)
#   ref:        looks for the file in the           <ref_dir>          (defined in config.xml)
#   extern:     looks for the file in the           <extern_dir>       (defined in config.xml)
#   additional: looks for the file in the subject's <additional_dir>   (defined in config.xml)
#   murfi_img:  looks for the file in the subject's <murfi_data_dir>/img
#   murfi_mask: looks for the file in the subject's <murfi_data_dir>/mask
#   full:       assumes the full path to the file is given
def getFullPathFromXMLblock(el):
	if el==None:
		return None
	basefile = el.text

	filepath_type = el.get('filetype')
	if filepath_type=="autoreg":
		filepath = os.path.join(subject['autoreg_data_dir'], basefile)
	elif filepath_type=="ref":
		filepath = os.path.join(config.find('ref_dir').text, basefile)
	elif filepath_type=="extern":
		filepath = os.path.join(config.find('extern_dir').text, basefile)
	elif filepath_type=="additional":
		filepath = os.path.join(subject['additional_dir'], basefile)
	elif filepath_type=="murfi_img":
		filepath = os.path.join(subject['murfi_data_dir'], 'img', basefile)
	elif filepath_type=="murfi_mask":
		filepath = os.path.join(subject['murfi_data_dir'], 'mask', basefile)
	else:
		filepath = basefile

	return filepath	

# Searches the current block for a specific tag and returns the string inside that tag
# If the tag is not found, it searches config.xml for the tag.  If it's still not found
# it returns the default
def blockConfFind(block, tag2find, default):

	if block.find(tag2find)==None:
		if config.find(tag2find)==None:
			return default
		else:
			return config.find(tag2find).text
	else:
		return block.find(tag2find).text

def parseReceiveBlock(block):		
	if block.get('type')=="murfi":		
		murfi_xml_infilename = config.find('murfi_xml').text + "/" + block.find('xml').text
		murfi_xml_outfilename = subject['murfi_config_dir'] + "/" + block.find('xml').text

		# Read in murfi's template xml
		murfi_xml_infile = open(murfi_xml_infilename, 'r')
		murfi_xml_generic = murfi_xml_infile.read()
		
		# Customize the xml
		# It'd be nice to use xml parser to set murfi params, but
		# murfi's xml isn't well formed

		murfi_xml_custom = murfi_xml_generic.replace("___XMLDIR___", subject['murfi_config_dir'])
		
		# NONOBVOUS: To get the direcotry structure to be well behaved		
		# murfi_xml_custom = murfi_xml_custom.replace("___DATADIR___", config.find('subject_dir').text)		
		# murfi_xml_custom = murfi_xml_custom.replace("___SUBNAME___", subject['name'])
		murfi_xml_custom = murfi_xml_custom.replace("___SUBNAME___", config.find('murfi_data_dir').text)
		murfi_xml_custom = murfi_xml_custom.replace("___DATADIR___", subject['subject_dir'])		
		murfi_xml_custom = murfi_xml_custom.replace("___MURFIDIR___", config.find('murfi_dir').text)

		# Write it to file
		print "    ---> Writing murfi config xml to: ", murfi_xml_outfilename
		murfi_xml_out = open(murfi_xml_outfilename, 'w')
		murfi_xml_out.write(murfi_xml_custom)
		murfi_xml_out.close()
		
		# Get a listing of images before running murfi
		imglist_before = glob.glob(os.path.join(subject['murfi_data_dir'], 'img', '*.nii'))

		# Execute murfi
		print "    ---> Waiting for data from VSEND..."
		murfi_exec = [config.find('murfi_binary').text, "-f", murfi_xml_outfilename]
		with open(os.devnull, "w") as devnull:				
			subprocess.call(murfi_exec, stdout=devnull, stderr=devnull)

		# Get a listing of images after running murfi
		imglist_after = glob.glob(os.path.join(subject['murfi_data_dir'], 'img', '*.nii'))

		# The file received is the difference between the after and before set
		received_files = set(imglist_after) - set(imglist_before)
		print "    ---> Received ", len(received_files), " file(s)"
		
		# Merge and copy the file to autoreg_data_dir, if required
		outfile = getFullPathFromXMLblock(block.find('outfile'))
		if outfile!=None:					
			fslmerge_exec = [config.find('fslmerge_binary').text, "-t", outfile]
			# Make sure you sort the list!!
			for file in sorted(received_files):
				fslmerge_exec.append(file)
			print "    ---> Merging the received files and copying to ", outfile
			with open(os.devnull, "w") as devnull:				
				subprocess.call(fslmerge_exec, stdout=devnull, stderr=devnull)

#		PW: 2012/11/03: Old.  Only works for 1 TR			
#		if outfile!=None:
#			outfile = getFullPathFromXMLblock(block, 'outfile')
#			print "    ---> Copying file to ", outfile
#			shutil.copy(receive_file, outfile)

	else:
		print "    !!-> Unrecognized ReceiveBlock type: ", block.get('type'), " skipping.."
		print 
		
def parseRegisterBlock(block):
	
	source = getFullPathFromXMLblock(block.find('src'))
	if source==None:
		print "    !!-> No source file defined.  Skipping.."
		return

	dest = getFullPathFromXMLblock(block.find('dest'))
	if dest==None:
		print "    !!-> No destination file defined.  Skipping"
		return
	
	out_vol = getFullPathFromXMLblock(block.find('out_vol'))
	if out_vol==None:
		print "    !!-> No output volume file defined.  Skipping"
		return

	out_trans = getFullPathFromXMLblock(block.find('out_trans'))
	if out_trans==None:
		print "    !!-> No output transformation file defined.  Skipping"
		return

	print "    ---> Source file:      ", source
	print "    ---> Destination file: ", dest
	print "    ---> Output volume:    ", out_vol
	print "    ---> Destination file: ", out_trans

	if block.get('type')=="flirt":
		# TODO: Clean up.  Use os.path.join()
		print "    ---> Using flirt to perform registration"

		flirt_dof = blockConfFind(block, 'flirt_dof', '-dof 12')
		flirt_seartch_angles = blockConfFind(block, 'flirt_search_angles', '-searchrx -90 90 -searchry -90 90 -searchrz -90 90')
		flirt_cost = blockConfFind(block, 'flirt_cost', '-cost mutualinfo')
		flirt_searchcost = blockConfFind(block, 'flirt_searchcost', '-searchcost mutualinfo')

		print "    ---> Degrees of freedom: ", flirt_dof
		print "    --->      Search Angles: ", flirt_seartch_angles
		print "    --->               Cost: ", flirt_cost
		print "    --->        Search Cost: ", flirt_searchcost

		flirt_cmd = config.find('flirt_binary').text + " " + flirt_dof \
                            + " " + flirt_seartch_angles + " " + flirt_cost + " " + flirt_searchcost \
                            + " -in " + source + " -ref " + dest + " -omat " + out_trans \
                            + " -out " + out_vol
		
		# Execute flirt
		print "    ---> Executing flirt...", flirt_cmd		
		with open(os.devnull, "w") as devnull:				
			subprocess.call(flirt_cmd.split(), stdout=devnull, stderr=devnull)			
			
	elif block.get('type')=="robust":
		print "    ---> Using mri_robust_register to perform registration"
		print "    !!-> Registering via mri_robust_register not implemented yet"
	else:
		print "    !!-> Unrecognized RegisterBlock type: ", block.get('type')

def parseRoiGenBlock(block):
	if block.get('type')=="feat":
		print "    ---> Using feat to perform ROI generation"		
		fsf_in = os.path.join(config.find('feat_fsf').text, block.find('fsf').text)
		fsf_out = os.path.join(subject['feat_config_dir'], block.find('fsf').text)
		print "    ---> Template fsf file: ", fsf_in

		# Read in feats's template xml
		feat_fsf_infile = open(fsf_in, 'r')
		feat_fsf_generic = feat_fsf_infile.read()
		
		# Customize the fsf
		# Template fsf should be in the format:
		#   set fmri(outputdir) "___OUTDIR___/fingerTap_90TR_10rest+10left+10rest+10right"
		feat_fsf_custom = feat_fsf_generic.replace("___OUTDIR___", subject['feat_data_dir'])

		# Template fsf should be in the format:
		#   set feat_files(1) "___FEATDATA___"
		#   feat doesn't want extensions on this...
		featdata = getFullPathFromXMLblock(block.find('infile'))
		featdata = re.sub("\..*","",featdata)
		feat_fsf_custom = feat_fsf_custom.replace("___FEATDATA___", featdata)

		# Write it to file
		print "    ---> Configuring template and saving to: ", fsf_out
		feat_fsf_out = open(fsf_out, 'w')
		feat_fsf_out.write(feat_fsf_custom)
		feat_fsf_out.close()

		
		# Run feat.  If no directory exists in subject['feat_data_dir'], feat will create
		# A directory namef fmri(outputdir) is fsf_out.  If this directory already exists, then
		# '+'s are appended to the direcotry name until one is found that doesn't exist. So to find
		# the diretory feat actually used, get the directory listing before and after running feat
		
		# Get a listing of feat directories before running murfi
		dirlist_before = glob.glob(os.path.join(subject['feat_data_dir'],'*'))

		print "    ---> Running feat: "
		feat_exec = [config.find('feat_binary').text, fsf_out]
		with open(os.devnull, "w") as devnull:				
			subprocess.call(feat_exec, stdout=devnull, stderr=devnull)

		# Get a listing of feat directories before running murfi
		dirlist_after = glob.glob(os.path.join(subject['feat_data_dir'],'*'))
		
		# The file received is the difference between the after and before set
		featdir_current = (set(dirlist_after) - set(dirlist_before)).pop()
		
		for outfile in block.findall('outfile'):
			srcfile = outfile.get('src')
			destfile_fullpath = getFullPathFromXMLblock(outfile)
			srcfile_fullpath = os.path.join(featdir_current, srcfile)
			print "    ---> Copying ", srcfile, " to ", destfile_fullpath
			shutil.copy(srcfile_fullpath, destfile_fullpath)

	else:
		print "    !!-> Unrecognized RoiGenBlock type: ", block.get('type')


def parseMathBlock(block):
	infile = getFullPathFromXMLblock(block.find('infile'))
	print "    ---> infile is", infile
	outfile = getFullPathFromXMLblock(block.find('outfile'))
	print "    ---> outfile is", outfile
	if block.get('type')=="fslmaths":
		print "    ---> Using fslmaths to perform volume creation/manipulation"
		fslmaths_exec = [config.find('fslmaths_binary').text]
		
		if block.find('datatype') != None:
			fslmaths_exec.append('-dt')
			fslmaths_exec.append(block.find('datatype').text)

		fslmaths_exec.append(infile)

		for op in block.findall('op'):
			if op.get('filetype') != None:
				opval = getFullPathFromXMLblock(op)		
			else:
				opval = op.text
			fslmaths_exec.append(op.get('flag'))
			if op.text != None:
				fslmaths_exec.append(opval)

		fslmaths_exec.append(outfile)

		if block.find('outdatatype') != None:
			fslmaths_exec.append('-odt')
			fslmaths_exec.append(block.find('outdatatype').text)

		print "    ---> Executing fslmaths:", fslmaths_exec
		subprocess.call(fslmaths_exec)
		#with open(os.devnull, "w") as devnull:				
			#subprocess.call(fslmaths_exec, stdout=devnull, stderr=devnull)

	else:
		print "    !!-> Unrecognized MathBlock type: ", block.get('type')

def parseTransformBlock(block):
	srcfile = getFullPathFromXMLblock(block.find('src'))
	print "    ---> srcfile is", srcfile

	outfile = getFullPathFromXMLblock(block.find('out_vol'))
	print "    ---> outfile is", outfile
	
	if block.get('type')=="flirt":
		transfile = getFullPathFromXMLblock(block.find('trans'))
		print "    ---> transfile is", transfile

		reffile = getFullPathFromXMLblock(block.find('ref'))
		print "    ---> reffile is", reffile
		
		flirt_exec = [config.find('flirt_binary').text]
		flirt_exec.append('-in')
		flirt_exec.append(srcfile)
		flirt_exec.append('-ref')
		flirt_exec.append(reffile)
		flirt_exec.append('-applyxfm')
		flirt_exec.append('-init')
		flirt_exec.append(transfile)
		flirt_exec.append('-out')
		flirt_exec.append(outfile)

		print "    ---> Executing flirt"
		with open(os.devnull, "w") as devnull:				
			subprocess.call(flirt_exec, stdout=devnull, stderr=devnull)
	else:
		print "    !!-> Unrecognized RegisterBlock type: ", block.get('type')

def parseConcatBlock(block):

	firstfile = getFullPathFromXMLblock(block.find('first'))
	print "    ---> firstfile is", firstfile

	secondfile = getFullPathFromXMLblock(block.find('second'))
	print "    ---> secondfile is", secondfile
	
	destfile = getFullPathFromXMLblock(block.find('dest'))
	print "    ---> secondfile is", destfile

	if block.get('type')=="convert_xfm":
		convert_exec = [config.find('convert_xfm_binary').text]
		convert_exec.append('-omat')
		convert_exec.append(destfile)
		convert_exec.append('-concat')
		convert_exec.append(secondfile)
		convert_exec.append(firstfile)

		print "    ---> Executing convert_xfm"
		with open(os.devnull, "w") as devnull:				
			subprocess.call(convert_exec, stdout=devnull, stderr=devnull)

	else:
		print "    !!-> Unrecognized RegisterBlock type: ", block.get('type')

def parseSkullstripBlock(block):
	infile = getFullPathFromXMLblock(block.find('infile'))
	print "    ---> infile is", infile

	outfile = getFullPathFromXMLblock(block.find('outfile'))
	print "    ---> outfile is", outfile

	if block.get('type')=="bet":
		convert_exec = [config.find('bet_binary').text]
		convert_exec.append(infile)
		convert_exec.append(outfile)
		convert_exec.append(getFullPathFromXMLblock(block.find('options')))

		print "    ---> Executing bet", convert_exec
		with open(os.devnull, "w") as devnull:				
			subprocess.call(convert_exec, stdout=devnull, stderr=devnull)

	else:
		print "    !!-> Unrecognized RegisterBlock type: ", block.get('type')

def parseVisBlock(block):
	if block.get('type')=="fslview":
		fslview_exec = [config.find('fslview_binary').text]
		for f in block.findall('file'):
			filename = getFullPathFromXMLblock(f)
			fslview_exec.append(filename)
		
		print "    ---> Executing fslview", fslview_exec
		with open(os.devnull, "w") as devnull:				
			subprocess.call(fslview_exec, stdout=devnull, stderr=devnull)
	
	else:
		print "    !!-> Unrecognized RegisterBlock type: ", block.get('type')

def main():

	# Get command line arguments
	options = getOptions();
	
	# Parse xml command file
	print "  ---> Parsing config file: " + options.file
	xml = ET.parse(options.file).getroot()
	
	initSubject(xml);

	if not options.initonly:
		# Parse each node in the config file
		num_blocks = 0
		for block in xml:
			num_blocks += 1
			if block.tag=="receive":
				print "  ---> Parsing block ", num_blocks, "as a 'receive' block..."
				parseReceiveBlock(block)
			elif block.tag=="register":
				print "  ---> Parsing block ", num_blocks, "as a 'register' block..."
				parseRegisterBlock(block)
			elif block.tag=="roi_gen":
				print "  ---> Parsing block ", num_blocks, "as a 'roi_gen' block..."
				parseRoiGenBlock(block)
			elif block.tag=="math":
				print "  ---> Parsing block ", num_blocks, "as a 'math' block..."
				parseMathBlock(block)
			elif block.tag=="transform":
				print "  ---> Parsing block ", num_blocks, "as a 'transform' block..."
				parseTransformBlock(block)
			elif block.tag=="concat":
				print "  ---> Parsing block ", num_blocks, "as a 'concat' block..."
				parseConcatBlock(block)
			elif block.tag=="skullstrip":
				print "  ---> Parsing block ", num_blocks, "as a 'skullstrip' block..."
				parseSkullstripBlock(block)
			elif block.tag=="vis":
				print "  ---> Parsing block ", num_blocks, "as a 'vis' block..."
				parseVisBlock(block)
			else:
				print "  ---> block", num_blocks, "has an unrecognized tag: ", block.tag, " skipping.."
			print "  ---> Done parsing node ", num_blocks

		# All done
	print "  ---> All done!"

if __name__ == "__main__":
    main()
