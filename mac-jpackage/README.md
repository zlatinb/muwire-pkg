# Building a .dmg with JPackage

### Requirements

* Java 16 or newer.  
* A code signing certificate issued by Apple.
* XCode 10 or newer

### Building

1. Set the `MW_SIGNER` environment variable to a string identifying the signer
1. Set the `MW_BUILD_NUMBER` environment variable to an integer >= 1
1. Run `build.sh`

### Notarization

1. You need an "app-specific password" which you can create at https://appleid.apple.com
2. Execute
```
xcrun altool --eval-app --primary-bundle-id com.muwire.gui -u <your Apple id> -f <name of the .dmg file>
```
This will ask you for the password you generated in step 1 and will return a long UUID string you can use to check the progress.

3. Periodically execute the following to check the progress of the notarisation:
```
xcrun altool --eval-info <the long UUID string> -u <your Apple id>
````
4. If that returns success, staple the notarization to the dmg:
```
xcrun stapler staple <name of the .dmg>
