<h1>AvatarSync</h1>
AvatarSync provides capabilities to synchronize profile pictures from various sources, like WhatsApp or Facebook.
The functionalities used require a jailbroken iOS device (7.0-8.2) and a compiled version can be found on TheBigBoss-repository.

<img src="https://raw.githubusercontent.com/wolfposd/avatarsync/master/AvatarSync_build_tools/screens/1.png" width="30%">
<img src="https://raw.githubusercontent.com/wolfposd/avatarsync/master/AvatarSync_build_tools/screens/2.png" width="30%">
<img src="https://raw.githubusercontent.com/wolfposd/avatarsync/master/AvatarSync_build_tools/screens/3.png" width="30%">

<h2>Implementing further functionality</h2>
For implementing further matching modes two options are possible:

<h3>Multiple Matching</h3>
One can add further matching capabilities by implementing <i>MatchingDelegate.h.</i> 
The implementing class needs to be added to the <i>MultipleBaseTableViewController.m</i> in its <i>viewDidLoad</i>-method

<h3>Single Matching</h3>
For adding a singlematcher there are multiple custom ways to do this. See <i>ImageApplyOptions.m#156</i> for examples.
