# Star-Smatter
My first demo, whoo! Decently happy with this one, even though a few parts were dropped.

This is a bit of a post-demo writeup to capture my thoughts just after releasing and seeing some of the feedback from this demo.

[pouët link](http://www.pouet.net/prod.php?which=79213)


## Lessons Learned
I learned that it's weird to go through the 'design' process of a demo… not that I expected I'd just be able to write a couple lines of code, but if you wanna make something decent that actually comes across to people, you need to have some overall vision, take the prod somewhere and all. Having the bit of a story element in this one helped. It is one of the most fun parts of making a demo though, trying to tie everything together and think of a theme for it.

Music syncing is essential, and can be pretty difficult. In this one, I handled the music syncing entirely manually, basically just with a list of durations in seconds. While this can work fine for some stuff – especially when it comes to e.g. changing music halfway through… nah, it doesn't.

For my next prod, I'm going to take a leaf out of the illustrious [4mat's book](https://4matprojects.blogspot.com/2016/08/making-ad-astra-13.html) and instead of having the music and scenes run independently, tie them to each other so that it's pretty much impossible for them to get desynced. I've done up an example in the `music_sync.p8` effects demo, and it looks like it works pretty well there. Took the idea of using `sync(20)` a bunch and wrote that example up, it's almost certainly very close to the method they explain in the post but hopefully it's different enough, esp with the scene skipping flag added in. From what I remember of how the orig worked, this one may be a toooouch more reliable? maybe not but eh I've tried.

Writing effects is difficult. Well, the more fun effects at least. There's a lotta math involved (I've learned/re-remembered a bunch about using sin and cos making this up ;D). Pretty happy with how the raster/copperbars turned out though, they were sorta the main effect at play in this demo. Tunnel'd be the second one, and while I'm relatively happy I got it done up, there's definitely better ways to do it in the future.


## Feedback
Most has been positive so far, which has been awesome! The demo community's super welcoming, heart skips a beat every time someone leaves a comment aha, and there's some really good advice/critiques in there:

-----

> o music, but not bad for firstie… i think it can be more complicated and more polished in changes of effects

Yeah this one I feel. I definitely wanna dig into more music theory and work out exactly what makes good stuff… Things like motifs, just plain listening to demo and game music that inspires me, etc. The effects note is important as well, especially the 6/7 effects I feel like I need to get more comfortable with. Not that I'm tryna pander or w/e but getting to the point of being able to write… convincing-sounding 'chip music', of the quality to be in a pro demo… that would be really cool. In general, I've always struggled with creating longer tracks as well, how to extend something longer than a couple bars, how to move between different sections in music, etc… That'll be something to work on.

Posts for me to review: [toby's music advice](http://www.twitlonger.com/show/n_1sothcs), [jason's leitmotifs post (and others on the site)](http://jasonyu.me/undertale-part-1/), [composition-structure post](http://lefthanded-sans.tumblr.com/post/152664369549/deconstructing-undertales-music-composition), [thoughts post](http://kingofthewilderwest.tumblr.com/post/143610717427/thoughts-on-the-undertale-ost), some basic stuff about chord progressions… I know there's a lotta stuff about UT but honestly the music of that inspires me a lot, aha.

Music for me to review: [UT OST](https://www.youtube.com/playlist?list=PLpJl5XaLHtLX-pDk4kctGxtF4nq6BIyjg), [DR OST](https://www.youtube.com/playlist?list=PLOM-BnUvRjr9u86OQ0ZniQkrlLTcVHvr4), [Earthbound OST](https://youtu.be/WgXqGBcGdX8), [dubmood's stuff](https://www.youtube.com/playlist?list=PL97625AA4FA1ABEE9), [4mat's stuff](https://www.youtube.com/playlist?list=PLlcXA8cBFlDiygVNIqvTGKiMi0LtqqP4U), [rez's stuff~](https://www.youtube.com/playlist?list=PLA6F20B87BDE6ECCE). All sorts of awesome chippy stuff out there to look at~

-----

> o scene changes... be more diverse dude!

Aha yeah, scene changes… With this one, it can be a little unclear how things go so I was intending for the scene changes to 'guide' people there. As implemented though it can be a bit boring to look at, will definitely experiment with some other options (esp for ones where directionality isn't really required to move the scene forward~).

-----

> The only little critique I have is the dot tunnel, it didn't really feel like it was moving forward.

Mmm, this was mooostly just cuz I was a bit unsure of how to accomplish it with the effect laid out as it is currently aha, should've taken a bit more time to properly work it out. In addition, paying a bit closer attention to the existing work out there when I try to clone effects wouldn't be bad at all :)

-----

> Like it, especially the first FX, very good idea!
>
> + good effects, also sinus tunnel and 3d rasters Oo

Aha I'm really glad this effect came across well, it took a fair bit of working and playing to get right… I really like taking existing effects and changing them up a bit, playing with 'em until I get something a bit more interesting than the stock-standard. Hearing this feedback's making me wanna do that even more in future!

-----

Honestly I'm surprised nobody commented about the name being a bit weird, and am just super happy people seem to like it. Lots of work to do for the next one!


## Overall
Pretty decent! I'm happy with it and am real surprised about the response. Lots of things for me to review and work on, and I'm excited to get started making something new.

Thanks for everyone who's commented, and hopefully this writeup's some intersting reading!

