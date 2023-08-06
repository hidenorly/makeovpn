#!/bin/bash 

#  Copyright (C) 2023 hidenorly
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Default Variable Declarations 
DEFAULT="Default.txt" 
FILEEXT=".ovpn" 
CRT=".crt" 
KEY=".3des.key" 
CA="ca.crt" 
TA="ta.key" 

#Ask for a Client name 
echo "Please enter an existing Client Name:"
read NAME 


#1st Verify that client’s Public Key Exists 
if [ ! -f $NAME$CRT ]; then 
 echo "[ERROR]: Client Public Key Certificate not found: $NAME$CRT" 
 exit 
fi 
echo "Client’s cert found: $NAME$CR" 


#Then, verify that there is a private key for that client 
if [ ! -f $NAME$KEY ]; then 
 echo "[ERROR]: Client 3des Private Key not found: $NAME$KEY" 
 exit 
fi 
echo "Client’s Private Key found: $NAME$KEY"

#Confirm the CA public key exists 
if [ ! -f $CA ]; then 
 echo "[ERROR]: CA Public Key not found: $CA" 
 exit 
fi 
echo "CA public Key found: $CA" 

#Confirm the tls-auth ta key file exists 
if [ ! -f $TA ]; then 
 echo "[ERROR]: tls-auth Key not found: $TA" 
 exit 
fi 
echo "tls-auth Private Key found: $TA" 

#Ready to make a new .opvn file - Start by populating with the 
default file 
cat $DEFAULT > $NAME$FILEEXT 

#Now, append the CA Public Cert 
echo "<ca>" >> $NAME$FILEEXT 
cat $CA >> $NAME$FILEEXT 
echo "</ca>" >> $NAME$FILEEXT

#Next append the client Public Cert 
echo "<cert>" >> $NAME$FILEEXT 
cat $NAME$CRT | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' >> $NAME$FILEEXT 
echo "</cert>" >> $NAME$FILEEXT 

#Then, append the client Private Key 
echo "<key>" >> $NAME$FILEEXT 
cat $NAME$KEY >> $NAME$FILEEXT 
echo "</key>" >> $NAME$FILEEXT 

#Finally, append the TA Private Key 
echo "<tls-auth>" >> $NAME$FILEEXT 
cat $TA >> $NAME$FILEEXT 
echo "</tls-auth>" >> $NAME$FILEEXT 

echo "Done! $NAME$FILEEXT Successfully Created."
