# AWS Panorama Appliance security features<a name="security-features"></a>

To protect your [applications, models](gettingstarted-concepts.md), and hardware against malicious code and other exploits, the AWS Panorama Appliance implements an extensive set of security features\. These include but are not limited to the following\.

****
+ **Full\-disk encryption** – The appliance implements Linux unified key setup \(LUKS2\) full\-disk encryption\. All system software and application data are encrypted with a key that is specific to your device\. Even with physical access to the device, an attacker cannot inspect the contents of its storage\.
+ **Memory layout randomization** – To protect against attacks that target executable code loaded into memory, the AWS Panorama Appliance uses address space layout randomization \(ASLR\)\. ASLR randomizes the location of operating system code as it is loaded into memory\. This prevents the use of exploits that attempt to overwrite or run specific sections of code by predicting where it is stored at runtime\.
+ **Trusted execution environment** – The appliance uses a trusted execution environment \(TEE\) based on ARM TrustZone, with isolated storage, memory, and processing resources\. Keys and other sensitive data stored in the trust zone can only be accessed by a trusted application, which runs in a separate operating system within the TEE\. The AWS Panorama Appliance software runs in the untrusted Linux environment alongside application code\. It can only access cryptographic operations by making a request to the secure application\.
+ **Secure provisioning** – When you provision an appliance, the credentials \(keys, certificates, and other cryptographic material\) that you transfer to the device are only valid for a short time\. The appliance uses the short\-lived credentials to connect to AWS IoT and requests a certificate for itself that's valid for a longer time\. The AWS Panorama service generates credentials and encrypts them with a key that is hardcoded on the device\. Only the device that requested the certificate can decrypt it and communicate with AWS Panorama\.
+ **Secure boot** – When the device starts up, each software component is authenticated before it runs\. The boot ROM, software hardcoded in the processor that can't be modified, uses a hardcoded encryption key to decrypt the bootloader, which validates the trusted execution environment kernel, and so forth\.
+ **Signed kernel** – Kernel modules are signed with an asymmetric encryption key\. The operating system kernel decrypts the signature with the public key and verifies that it matches the module's signature before loading the module into memory\.
+ **dm\-verity** – Similar to how kernel modules are validated, the appliance uses the Linux Device Mapper's `dm-verity` feature to verify the integrity of the appliance software image before mounting it\. If the appliance software is modified, it won't run\.
+ **Rollback prevention** – When you update the appliance software, the appliance blows an electronic fuse on the SoC \(system on a chip\)\. Each software version expects an increasing number of fuses to be blown, and can't run if more are blown\.