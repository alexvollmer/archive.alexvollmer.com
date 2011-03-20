----- 
sha1: b4e0f49d68e996e0dff61659414a71204879fc17
kind: article
permalink: cleaning-out-the-closet
created_at: 2009-11-07 22:12:45 -08:00
title: Cleaning out the Closet
excerpt: ""
original_post_id: 414
tags: 
- ruby
toc: true
-----
I've had a couple of nascent Ruby gems lurking in my Github account for what seems like ages. So, on a rainy Saturday afternoon, I did a little cleanup and pushed a couple of new gems out to [Gemcutter](http://gemcutter.org).

The first, is a gem I started over a year ago, called <a href="http://gemcutter.org/gems/word-salad" target="_new">`word-salad`</a>. It uses the built-in dictionary file to randomly pull words out. This is great when you just need to generate a bunch of English-like text, but don't want to fall back on the boring old "lorem ipsum&hellip;" routine.

<% highlight :ruby do %>
3.words ==> ['draw', 'ameliorate', 'bonanza']
2.sentences ==> ['Shoot jonesing the make castle.', 'Blue murdered slight bastion.']
2.paragraphs ==> ["Brachypterous gastropod pheretrer overeager toploftily denaturalization stokesite demented benzalhydrazine archaeologic. Haverer hypophonous lenticularly brickliner urocele paucipinnate pik unprintably perhalogen. Subglenoid bearish gesticulative staircase gallop vesuvianite pneumatically overyear conterminous dreamish. Nonalliterated galliwasp superconfirmation Comandra entoil millionth parcellize rarefaction Cynoidea. Podolian metamorphosable nativeness integriously protonematoid undoctor stochastically dissatisfactory unchastity.", "Increate unloquacious unsatisfiedly flareboard internuncio beguine equivocation snowshoe Rhynchonellacea. Parochially curliewurly vermix consistorial cond consciencelessness Anaxagorize recoct sempiternally Campanulatae. Scorpionida Castalides homoanisic semipenniform Novemberish assessor preterlethal acrotarsial knoller hartin. Procrastination boatwise canonize differentiate faunlike countermarriage obstinance dilatableness drumloid. Gerate squirr Silvanus Physostigma booting thyroarytenoid diminutival legpuller medisance radiobserver."]
<% end %>


The second is a gem for automatically retrieving and locally storing sales reports from the iTunes Connect site. If you have an iPhone app in the App Store, you already know how much (anti-)fun it is to get reports from Apple's site. So I put the <a href="http://gemcutter.org/gems/itunes-connect" target="_new">`itunes-connect`</a> gem together to help out. It's pretty basic for now, but will probably grow more capabilities as time goes on.
