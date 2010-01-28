----- 
kind: article
permalink: prototyping-with-briefs
title: Prototyping with Briefs
created_at: 2010-01-10 17:40:40 -08:00
tags:
- iphone
- UX
excerpt: ""
original_post_id: 435
toc: true
-----
One of the best sessions I saw at the 2009 WWDC was titled "Prototyping iPhone User Interfaces". In this session, Bret Victor laid out a strategy and some techniques for building cheap prototypes on the the device in lieu of "static" mockups.

After returning from WWDC I was inspired to try this technique out and after playing with the idea for a bit, it was clear that there was a lot of repetition in the process. To really make prototyping cheap, we need a simple framework that makes the process fast and easy. Enter [Briefs](http://github.com/capttaco/Briefs), a lightweight iPhone application that allows you to embed and run simple prototypes built with nothing more than images and a property list.

With Briefs, you don't write a separate application for the device (imagine the provisioning headaches), but instead embed separate prototypes (called "briefs") into a single Briefs application. Briefs is still pretty new and I expect to see (and contribute) many enhancements, but if you like this style of application development, it's certainly worth spending some time with Briefs.

Let's look at how it works. We're going to start with the goal of prototyping the built-in Photos application. Now obviously, nobody is going to actually _re-write_ the Photos app, but since we all have familiarity with it, it's a good example to see how a working application can be expressed as a Briefs prototype.

# Getting Briefs

Before we do anything, we need to get Briefs on our local machine. Briefs is distributed in source-only form via [GitHub](http://github.com/capttaco/Briefs). You'll need to find a nice place to check out the two main Briefs project, then do the following:

$ git clone git://github.com/capttaco/Briefs.git
$ git clone git://github.com/capttaco/Briefs-util.git
$ cd Briefs
$ git submodule update -i


In order to put our first Brief together, we need to build a command-line tool that is part of the Briefs project. Open the Xcode project in the Briefs folder (`Briefs.xcodeproj`) and select the "Briefs Compactor" target and set the architecture to "Base SDK".

![Screen shot 2010-01-10 at 7.50.17 AM.png](/images/2010/01/Screen-shot-2010-01-10-at-7.50.17-AM.png)

Now execute the target to build the `compact-briefs` executable. When it's finished, Xcode will put the final binary in `build/Debug/compact-briefs` in the Briefs project directory. Copy this file to a location in your `$PATH`. Personally I like to keep such stuff in `~/bin`. We'll need this command in a little bit.

# How it Works

Before we dive into our project, we should get a little terminology under our belt. Each application prototype you create is called a "Brief". Each Brief is composed of one or more "Scenes". Scenes usually have an associated image, so you can think of a scene and a screen in the application as being more or less equivalent.

Scenes can also have any number of "Actors", which are regions on the screen that perform some action when touched. For example, to mimic navigating to a new view via a view controller, a region on a table view could be rigged to an action that slides another scene into place.

Briefs are expressed as Property List (Plist) files in the Briefs application. If you like writing XML or are proficient with the Property List Editor application, then you're golden. Otherwise there is another format in which you can write your brief that compiles down to a final Plist. This is the route we'll explore in our prototype.

# Protyping Photos.app

## Generate Image Files

Now let's generate the image files for our prototype. In the case of the existing Photos app, I just screen-captured the running application on the simulator. Obviously, you won't be in the same position with a new application, so you'll need to generate some images by hand.

If you use OmniGraffle, there are several good iPhone stencil sets on [Graffletopia](http://graffletopia.com/categories/iphone). If you prefer Photoshop, checkout the exhaustive [iPhone GUI PSD](http://www.teehanlax.com/blog/2009/06/18/iphone-gui-psd-30/). Either one of them will generate the appropriate files. There's no requirement that the image files _look_ like the iPhone. You could use a  tool like [Balsamiq](http://www.balsamiq.com/products/mockups) or scan hand-drawn sketches to generate very simple wireframe sketches. Regardless, all you need to do is produce PNG, GIF or JPEG files that fit within the normal iPhone dimensions (320 x 480).

Let's create a folder called "photos app" and put our image files in it. I've created [a tar-ball of this entire project](http://alexvollmer-public.s3.amazonaws.com/photos_app.tgz), which you can download, explore and run.

## Writing the Brief

Let's think a bit about the flow of our application. We're only going to implement a sub-set of Photo.app's full navigation&mdash;we'll just implement the flow for the Hawaii photo album. We have a top-level screen that shows all of the photo albums. From there the user can select "Hawaii" and drill into a display of a few images in the album. Touching any of the images will take the user into the image browser where users can go back and forth between the various images. Each screen has a common "back" button in the top-left. The overall screen layout and flow looks like this:

<a name="app-flow">![photos-app-flow.png](/images/2010/01/photos-app-flow.png)</a>

The pink boxes highlight the touchable areas in each scene. The arrows between them show which scene a particular area navigates to. In Briefs-parlance, each screen is a "Scene" and each pink box is an "Actor".

Let's step through the Brief (the `photos.bs` file), a bit at a time. If you get lost, refer back to the [application flow diagram](#app-flow) above.

First we declare that our starting scene is the "Home" scene. Next, we define that scene with the image `home.png` as the background image and one actor that will navigate to the next scene. The position and size of this actor corresponds to the table cell labeled "Hawaii". If we wanted to support the table rows, we'd need to add an actor for each one. 

When the user touches the "Hawaii" row, we'll transition the "Hawaii" scene (defined shortly) by executing a "push left" animation. This will mimic the standard animation of pushing a new view controller onto the navigation controller stack:

start:Home
scene:Home
  image:home.png
  actor:HawaiiPictures 
    position:0,123 
    wh:320,53
    action:goto(Hawaii, push left)


Next, we'll define a scene that shows the thumbnail images for each photo in the Hawaii album. This scene will display the `hawaii.png` background image and has an actor for the return navigation button in the upper-left as well as for each thumbnail image. Note the differences in the direction of the push animation in the actors. The "back" button pushes right (like the normal return navigation animation), while the thumbnails push left.
    
scene:Hawaii
  image:hawaii.png
  actor:Home 
    position:17,30 
    wh:87,24 
    action:goto(Home, push right)
  actor:image1 
    position:5,69 
    wh:72,72 
    action:goto(Image1, push left)
  actor:image2
    position:84,70
    wh:72,72
    action:goto(Image2, push left)
  actor:image3
    position:162,70
    wh:72,72
    action:goto(Image3, push left)


Now we'll define the scenes for each of the three images. Each image scene has an actor for the return navigation button in the top-left. The first image also has two actors to navigate to the next image. The `NextImage` actor is for the navigation button in the toolbar, whereas the `NextImageSwipe` actor covers the right side of the image itself. This is done to mimic the swiping motion normally used to navigate photos. Right now, Briefs only supports single-touch interactions so it won't behave _exactly_ like the real application in supporting swipes.
  
scene:Image1
  image:image1.png
  actor:NavigateBack 
    position:14,33 
    wh:44,23 
    action:goto(Hawaii, push right)
  actor:NextImage 
    position:202,450 
    wh:23,17 
    action:goto(Image2, push left)
  actor:NextImageSwipe 
    position:156,60 
    wh:160,380 
    action:goto(Image2, push left)


The "Image2" scene is a lot like the "Image1" scene, except that it has button and swipe actors for both the previous and next images:

scene:Image2
  image:image2.png
  actor:NavigateBack 
    position:14,33 
    wh:44,23 
    action:goto(Hawaii, push right)
  actor:PreviousImage 
    position:94,452 
    wh:23,17 
    action:goto(Image1, push right)
  actor:PreviousImageSwipe 
    position:0,60 
    wh:160,380 
    action:goto(Image1, push right)
  actor:NextImage 
    position:202,450 
    wh:23,17 
    action:goto(Image3, push left)
  actor:NextImageSwipe 
    position:156,60
    wh:160,380 
    action:goto(Image3, push left)


Finally, the last image scene. It only has "backward" navigation in the photo set since we've only put three photos in our album:

scene:Image3
  image:image3.png
  actor:NavigateBack 
    position:14,33 
    wh:44,23 
    action:goto(Hawaii, push right)
  actor:PreviousImage 
    position:94,452 
    wh:23,17 
    action:goto(Image2, push right)
  actor:PreviousImageSwipe 
    position:0,60 
    wh:160,380 
    action:goto(Image2, push right)


We've just done simple scene-to-scene transitions in this Brief, but there are also several transitions you can perform directly on actors such as moving them, fading them in and out and others. I've created a [syntax cheatsheet](http://alexvollmer-public.s3.amazonaws.com/Briefs%20Cheatsheet.pdf) which you can use as a reference for your own Briefs.

## Compiling the Brief

Once we have our photos, it's time to start writing our Brief. As mentioned earlier, the Briefs application consumes Plist files. However you can't just create one out of the box because it will only have image file _references_ in it, but not the actual data. The reason we built the `compact-briefs` command earlier, was so that we could take our intermediate Briefs file (usually called a _source_ brieflist) and embed the image data directly in the final product.

However I find editing XML tiresome, whether it's by hand or with a tool. Briefs provides an alternate syntax in which to write briefs which is transformed by a Ruby script into the intermediate Plist format. You can then compile the source brieflist to the final format using the `compact-briefs` command. The flow between formats and tools looks like this:

![briefs-flow.png](/images/2010/01/briefs-flow.png)

In the `Briefs-util` project (which you checked out earlier), you can find the Ruby script in `BS/bs`. I run these tools all at once in a script named `compile`:

#!/bin/bash
~/Development/Briefs-util/BS/bs photos.bs > photos-source.brieflist && \
	~/bin/compact-briefs photos-source.brieflist ~/Development/Briefs/sample/photos.brieflist

## Installing the Brief

The next step is to build the Briefs application with our newly-compiled Brief. Switch back to the Briefs Xcode project and choose the "Briefs" application target. If you haven't yet added the new brief to the Xcode project, right-click on the "My Briefs" and choose Add > Existing Files. Select the `photos.brieflist` file in the `samples` directory and in the following dialog make sure the checkbox at the top is unselected.

![Screen shot 2010-01-10 at 2.08.27 PM.png](/images/2010/01/Screen-shot-2010-01-10-at-2.08.27-PM.png)

Now you can build the Briefs application for either the simulator or the device. If you're building for the device, make sure you have a proper provisioning profile in place that matches the bundle identifier of the project. Now we can Build & Run the project, and our `photos.brieflist` should appear in the list:

![Screen shot 2010-01-10 at 8.54.47 AM.png](/images/2010/01/Screen-shot-2010-01-10-at-8.54.47-AM.png)

Select our new Brief and play with the application. To exit a Brief, touch and hold your finger down until a new screen appears asking you if you want to exit the current Brief.

![Screen shot 2010-01-10 at 11.54.51 AM.png](/images/2010/01/Screen-shot-2010-01-10-at-11.54.51-AM.png)

## Distributing the Brief

The idea behind these prototypes is putting a tangible example in front of users to get their feedback. So what do you do if you want to distribute Briefs to a wider audience? Ad-hoc builds are a pain and require access to the physical device. Fortunately, Briefs provides a tool called "Briefcasts", which is simply one or more Briefs embedded in an RSS feed. The Briefs application can retrieve Briefcasts via HTTP, so distributing Briefs is a snap if you have a web server to serve new Briefcasts from. This means you can install the Briefs application once on a device and provide updates anytime without having direct access to the hardware.

Currently, there isn't a tool to easily create a Briefcast directly out of a list of Briefs. For now, the project web site recommends copying and modifying the RSS template below:

<?xml version="1.0"?>
<rss version="2.0">
  <channel>
    <title>*Briefcast Demo*</title>
    <link>*http://island.local/~alex/briefcasts/*</link>
    <description>*Demonstrate how awesome it is to use a briefcast to get briefs on the iPhone.*</description>
    <language>en-us</language>
    *Thu, 12 Nov 2009 03:05:00 GMT*</pubDate>
    <lastBuildDate>*Thu, 12 Nov 2009 03:05:00 GMT*</lastBuildDate>
    <item>
      <title>*Photos.app Sketch*</title>
      <enclosure url="*http://island.local/~alex/briefcasts/photos.brieflist*" length="*954708*" type="application/brief" />
      <description>*An example brief of the built-in Photos.app.*</description>
      *Sun, 13 Sep 2009 03:05:00 GMT*</pubDate>
      <guid>*http://island.local/~alex/cast/1#item1*</guid>
    </item>
  </channel>
</rss>


The bits marked *in bold* need to replaced with your particular details. In the example above I only have one Brief, but if you had more than one, you would just include additional <code><item></code> elements. You need to have this RSS file on disk as well as the brieflist file referred to in the <code><enclosure></code> tag.

Assuming that you have your web server all setup with the RSS file as well as the Briefs files, you can launch the application and add the Briefcast by selecting the "+" button in the top-right of the home screen. Enter the details on the next dialog and touch the "Save" button:

![Screen shot 2010-01-10 at 9.20.37 AM.png](/images/2010/01/Screen-shot-2010-01-10-at-9.20.37-AM.png)

On the next screen you'll see the details of the Briefcast. Each Brief in the Briefcast will be listed under the section titled "Enclosed Briefs". Touch the "Download this Brief" button to retrieve the associated brief.

![Screen shot 2010-01-10 at 9.20.49 AM.png](/images/2010/01/Screen-shot-2010-01-10-at-9.20.49-AM.png)

Once the brief is downloaded, you end up on a rather unhelpful confirmation screen:

![Screen shot 2010-01-10 at 9.16.27 AM.png](/images/2010/01/Screen-shot-2010-01-10-at-9.16.27-AM.png)

You have to touch the screen, then navigate back to the top. Then you'll find the new Brief in your list of briefs. To update the Brief, you navigate back into the Briefcast section from the home page and download the correct Brief again.

One nice enhancement I'd love to see is a custom application URL for Briefs so that you could just email the link to someone. They could read the email from their device, select the URL and Briefs would launch and download the newest Briefs.

# Conclusion

Briefs is a great tool for building live prototypes. Since it's a relatively young project, it still has a lot of rough edges, but I expect it to mature over time. 

Don't hesitate to dive into the code behind Briefs. There are occasions when Briefs (the application or the command-line tool) will crash without much detail. I found that this is usually the result of bad syntax in the Briefs so a little sleuthing may be required to get things working.

# Resources

Here's a list of related resources:
*  [Briefs Homepage](http://giveabrief.com/)
*  [Briefs on GitHub](http://github.com/capttaco/Briefs)
*  [Sample Brief of Photos.app](https://alexvollmer-public.s3.amazonaws.com/photos_app.tgz)
*  [Briefs Syntax Cheatsheet](https://alexvollmer-public.s3.amazonaws.com/Briefs%20Cheatsheet.pdf)
*  [iPhone Templates for OmniGraffle](http://graffletopia.com/categories/iphone)
*  [iPhone PSD for PhotoShop](http://www.teehanlax.com/blog/2009/06/18/iphone-gui-psd-30/)



