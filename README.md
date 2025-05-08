 disable file installations 
     Settings -> Apps -> advanced app settings -> Choose where to get apps -> Microsoft Store Only (recommended)
 this will make it so standard accounts can only install apps from the ms store and not from any installer files
 
 disable microsoft store 
 press ctrl + r then type in gpedit.msc and hit enter
 navigate to 
 Computer Configuration -> Administrative Templates -> Windows Components -> Store
 double click on Turn off the store application and enable the policy. 
 
 reboot 

 This will block all instalations, including on admin profiles. 
 to allow an admin to install files switch the setting for where to get apps back to anywhere
