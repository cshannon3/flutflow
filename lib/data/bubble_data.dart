
import 'dart:math';

import 'package:flutflow/components/category_bubble.dart';
import 'package:flutflow/components/item_node.dart';
import 'package:flutter/material.dart';

Map<String, Color> catColors = {
  "Neuroscience":Colors.green,
  "Networks":Colors.blue,
  "AI": Colors.red,
  "Math": Colors.amber,
  "Music":Colors.deepPurple,
  "General":Colors.deepOrange,
  "Youtube":Colors.white,
  "Computers":Colors.cyan
};

List<CategoryBubble> subs =[
  CategoryBubble(
    name: "Neuroscience",
    color: catColors["Neuroscience"], 
    id:0,
    centerAbout: Point(0.15,0.3),
    diameter: 0.2
    
  ),
  CategoryBubble(
          name: "Networks", 
          color: catColors["Networks"], 
          centerAbout: Point(0.7,0.22),
          diameter: .15
  ),
   CategoryBubble(
          name: "AI", 
          color: catColors["AI"], 
          centerAbout: Point(0.15,0.7),
          diameter: .2
          ),
          CategoryBubble(
          name: "Math", 
          color: catColors["Math"], 
          centerAbout: Point(0.3,0.7),
          diameter: .15
          ),
  CategoryBubble(
          name: "Music", 
          color: catColors["Music"], 
          centerAbout: Point(0.7,0.73),
          diameter: .15
          ),
      CategoryBubble(
          name: "General", 
          color: catColors["General"], 
          centerAbout: Point(0.75,0.5),
          diameter: .15
          ),
            CategoryBubble(
          name: "Computers", 
          color: catColors["General"], 
          centerAbout: Point(0.3,0.2),
          diameter: .15
          ),
   
];

List<ItemNode> bubs =[
   ItemNode(
     id: 0,
      fontColor:Colors.black,
        imgUrl:"https://thebrain.mcgill.ca/flash/d/d_06/d_06_cr/d_06_cr_mou/d_06_cr_mou_4a.jpg", 
        name:"The Brain McGill", 
        url:"https://thebrain.mcgill.ca/index.php",
        categories: ["Neuroscience"],
       
        description: '''
        '''
        ),
        ItemNode(
        id: 1,
        fontColor:Colors.black,
        imgUrl:"http://what-when-how.com/wp-content/uploads/2011/08/tmp314_thumb.jpg", 
        name:"Network Models", 
        url:"https://what-when-how.com/data-communications-and-networking/network-models-data-communications-and-networking/",
        categories: ["Networks"],
        description: '''
        '''

        ),
        ItemNode(
     id: 2,
     fontColor:Colors.black,
        imgUrl:"http://networksciencebook.com/images/ch-01/figure-1-6.jpg", 
        name:"Network Science", 
        url:"http://networksciencebook.com/",
        categories: ["Networks"],
        description: '''
        '''
        ),
        ItemNode(  
     id: 3,
        imgUrl:"https://www.thevirtualbrain.org/tvb/static/style/img/logo_tvb_main.svg", 
        name:"Virtual Brain", 
        url:"https://www.thevirtualbrain.org/tvb/zwei/brainsimulator-software",
        categories: ["Neuroscience", "AI"],
        description: '''
        '''
        ),
        ItemNode(
     id: 4,
        imgUrl:"https://agi.io/wp-content/uploads/2019/10/logo-inverse-brown.png", 
        name:"Project AGI", 
        url:"https://agi.io/",
        categories: ["AI"],
        description: '''
        '''
        ),
        ItemNode(
     id: 5,
        imgUrl:"https://i1.wp.com/portal.bluebrain.epfl.ch/wp-content/uploads/2019/07/BBP_megapaper_header_homepage_1.jpg", 
        name:"Blue Brain Portal", 
        url:"https://portal.bluebrain.epfl.ch/",
        categories: ["Neuroscience"],
        description: '''
        '''
        ),
         ItemNode(
     id: 6,
      fontColor:Colors.blue,
        imgUrl:"https://avatars2.githubusercontent.com/u/22019253?s=200&v=4", 
        name:"Distill", 
        url:"https://distill.pub/",
        categories: ["AI"],
        description: '''

        '''
        ),

         ItemNode(
     id: 7,
        imgUrl:"https://www.asimovinstitute.org/wp-content/uploads/2019/04/AsinRound-300x300.png", 
        name:"THE ASIMOV INSTITUTE", 
        url:"https://www.asimovinstitute.org/neural-network-zoo-prequel-cells-layers/",
        categories: ["AI"],
        description: '''
        sjffff

        '''
        ),
         ItemNode(
     id: 8,
        imgUrl:"https://static1.squarespace.com/static/54f63048e4b0a47e92eb5234/t/5b6090050e2e72e41d141150/1577061339342/?format=1000w", 
        name:"Quaternions", 
        url:"https://eater.net/quaternions/video/intro",
        categories: ["Math"],
        description: '''
        sapvi;h
        svnps

        vjpsao ;lj
        '''
        ),
         ItemNode(
     id: 9, fontColor:Colors.black,
        imgUrl:"https://lh3.googleusercontent.com/vOToo-3knoqpS4oL0YpNZG5EN93aH5TPhwH4tdCqP_tIpPw8fiRKycf5H-EpPquZwhU=s180", 
        name:"Hook Theory", 
        url:"https://www.hooktheory.com/trends",
        categories: ["Music"],
        description: '''
        vwnjlas,mvn alks.,v
        vslkz,vn
        vsjikr
        '''
        ),
        ItemNode(
     id: 10,
        imgUrl:"https://magenta.tensorflow.org/assets/magenta-logo-bottom-text.png", 
        name:"Magenta", 
        url:"https://magenta.tensorflow.org/demos/community/",
     
        categories: ["Music","AI" ],
        description: '''
        zksvjnriol
        avnilr
        vmros
        '''
        ),
        ItemNode(
     id: 11,
        imgUrl:"https://149366099.v2.pressablecdn.com/wp-content/uploads/2019/03/FarnamStreet_Icon_NoBackground-copy.png", 
        name:"Farnam Street", 
        url:"https://fs.blog/",
        categories: ["General" ],
        description: '''
Farnam Street is a blog and the creator of "The Knowledge Project" podcast. They focus on distilling the wisdom from the countless books they have read and through interviews with successful people from every discipline. If you like Tim Ferris, you will also like Farnam Street.
Favorite Articles
- #linkhttps://fs.blog/2016/04/munger-operating-system/##size16##italic#The Munger Operating System#/color##/link##/italic#
- #linkhttps://fs.blog/2016/06/value-grey-thinking/##size16##italic#The Value of Grey Thinking#/color##/link##/italic#
- #linkhttps://fs.blog/2016/08/daniel-pink-two-types-of-motivation/##size16##italic#Daniel Pink on Incentives and the Two Types of Motivation#/color##/link##/italic#

        '''
        ),
         ItemNode(
     id: 12,
     fontColor: Colors.black,
        imgUrl:"https://stratechery.com/wp-content/uploads/2018/03/stratechery-logomark.png", 
        name:"Stratechery", 
        url:"https://stratechery.com/",
        categories: ["General" ],
        description: '''
        zksvjnriol
        avnilr
        vmros
        '''
        ),
            ItemNode(
               fontColor: Colors.black,
     id: 13,
        imgUrl:"https://upload.wikimedia.org/wikipedia/commons/thumb/b/b2/Y_Combinator_logo.svg/1200px-Y_Combinator_logo.svg.png", 
        name:"Paul Graham", 
        url:"http://www.paulgraham.com/articles.html",
        categories: ["General" ],
        description: '''
        zksvjnriol
        avnilr
        vmros
        '''
        ),
         ItemNode(
               fontColor: Colors.black,
     id: 14,
        imgUrl:"https://yt3.ggpht.com/a/AGF-l785JsRUb9Bf3NT_Y2yIla9xx4Y3F2nxEwXU0g=s288-c-k-c0xffffffff-no-rj-mo", 
        name:"Crash course", 
        url:"https://www.youtube.com/channel/UCX6b17PVsYBQ0ip5gyeme-Q",
        categories: ["General", "Youtube"],
        description: '''
        zksvjnriol
        avnilr
        vmros
        '''
        ),
         ItemNode(
               fontColor: Colors.black,
     id: 15,
        imgUrl:"https://yt3.ggpht.com/a/AGF-l79JUllK_KvggxDbg1MTLFAS2BfoD4QN0ZyqiA=s288-c-k-c0xffffffff-no-rj-mo", 
        name:"Explaining Computers", 
        url:"https://www.youtube.com/channel/UCbiGcwDWZjz05njNPrJU7jA",
        categories: ["Computers", "Youtube" ],
        description: '''
        zksvjnriol
        avnilr
        vmros
        '''
        ),
        
         ItemNode(
               fontColor: Colors.black,
     id: 16,
        imgUrl:"https://yt3.ggpht.com/a/AGF-l7_cklcDqiTOOLQ3cssUfGweO6z7xU7QHZ9mrA=s288-c-k-c0xffffffff-no-rj-mo", 
        name:"GreatScott!", 
        url:"https://www.youtube.com/channel/UC6mIxFTvXkWQVEHPsEdflzQ",
        categories: ["Computers", "Youtube" ],
        description: '''
        zksvjnriol
        avnilr
        vmros
        '''
        ),
          ItemNode(
               fontColor: Colors.black,
     id: 17,
        imgUrl:"https://yt3.ggpht.com/a/AGF-l78T_3vy2GrbqROEtHhTb_X7UymsLpvroI18Bw=s288-c-k-c0xffffffff-no-rj-mo", 
        name:"ElectroBOOM", 
        url:"https://www.youtube.com/channel/UCJ0-OtVpF0wOKEqT2Z1HEtA",
        categories: ["Computers", "Youtube" ],
        description: '''
        zksvjnriol
        avnilr
        vmros
        '''
        ),
          ItemNode(
               fontColor: Colors.black,
     id: 18,


        imgUrl:"https://yt3.ggpht.com/a/AGF-l7_90_OopgqRNxh6zi7bhcOT8SHeQLbJDR1ZFQ=s288-c-k-c0xffffffff-no-rj-mo", 
        name:"minutephysics", 
        url:"https://www.youtube.com/channel/UCUHW94eEFW7hkUMVaZz4eDg",
        categories: ["Math", "Youtube" ],
        description: '''
        zksvjnriol
        avnilr
        vmros
        '''
        ),
          ItemNode(
               fontColor: Colors.white,
     id: 19,
        imgUrl:"https://yt3.ggpht.com/a/AGF-l78WZLN2Z3fJWwxWJEFSTsNt9ru-apt0k5D5mg=s288-c-k-c0xffffffff-no-rj-mo", 
        name:"Lex Fridman", 
        url:"https://www.youtube.com/channel/UCSHZKyawb77ixDdsGog4iWA",
        categories: ["AI", "Youtube" ],
        description: '''
        zksvjnriol
        avnilr
        vmros
        '''
        ),
          ItemNode(
               fontColor: Colors.black,
     id: 20,
        imgUrl:"https://yt3.ggpht.com/a/AGF-l78aqICcIC0AZLKo1GDDvYmIAtbAPmCSipDGiw=s288-c-k-c0xffffffff-no-rj-mo", 
        name:"Paul Davids", 
        url:"https://www.youtube.com/channel/UC_Oa7Ph3v94om5OyxY1nPKg",
        categories: ["Music", "Youtube" ],
        description: '''
        zksvjnriol
        avnilr
        vmros
        '''
        ),
          ItemNode(
               fontColor: Colors.white,
     id: 21,
        imgUrl:"https://yt3.ggpht.com/a/AGF-l78AFyS6S0d-j36ZsnkHlOZHI6CHMsMatKPkOw=s288-c-k-c0xffffffff-no-rj-mo", 
        name:"Jon Bellion", 
        url:"https://www.youtube.com/channel/UCesblIDGtEt0UQ4gurl8vnw",
        categories: ["Music", "Youtube" ],
        description: '''
        zksvjnriol
        avnilr
        vmros
        '''
        ),

          ItemNode(
               fontColor: Colors.black,
     id: 22,
        imgUrl:"https://yt3.ggpht.com/a/AGF-l78mj7JeAO5BP2BChvanMZI_CwgPYq-g7fXBUg=s288-c-k-c0xffffffff-no-rj-mo", 
        name:"Wintergatan", 
        url:"https://www.youtube.com/channel/UCcXhhVwCT6_WqjkEniejRJQ",
        categories: ["Music", "Youtube" ],
        description: '''
        zksvjnriol
        avnilr
        vmros
        '''
        ),
          ItemNode(
               fontColor: Colors.white,
     id: 23,
        imgUrl:"https://yt3.ggpht.com/a/AGF-l7_vzcOHoE01somM6NpHXkQR4epTHNRGQW6YrA=s288-c-k-c0xffffffff-no-rj-mo", 
        name:"Jabrils", 
        url:"https://www.youtube.com/channel/UCQALLeQPoZdZC4JNUboVEUg",
        categories: ["AI", "Youtube" ],
        description: '''
        zksvjnriol
        avnilr
        vmros
        '''
        ),
           ItemNode(
               fontColor: Colors.white,
     id: 24,
        imgUrl:"https://yt3.ggpht.com/a/AGF-l79V4LblHGweW2p2VQpDEsUMEgvbNlo_o4rciA=s288-c-k-c0xffffffff-no-rj-mo", 
        name:"12tone", 
        url:"https://www.youtube.com/channel/UCTUtqcDkzw7bisadh6AOx5w",
        categories: ["Music", "Youtube" ],
        description: '''
        zksvjnriol
        avnilr
        vmros
        '''
        ),
           ItemNode(
               fontColor: Colors.white,
     id: 25,
        imgUrl:"https://yt3.ggpht.com/a/AGF-l78RivbTspXaUGCmw5lW_qj7-uQAV5dfzLDjQw=s288-c-k-c0xffffffff-no-rj-mo", 
        name:"Andrew Foy", 
        url:"https://www.youtube.com/channel/UCuNVQeVXwfwxVUKdrCQgk3A",
        categories: ["Music", "Youtube" ],
        description: '''
        zksvjnriol
        avnilr
        vmros
        '''
        ),
           ItemNode(
               fontColor: Colors.white,
     id: 26,
        imgUrl:"https://yt3.ggpht.com/a/AGF-l78avQgRgHwpa08YwHEmylI9nkSURriUpOqOFw=s288-c-k-c0xffffffff-no-rj-mo", 
        name:"deeplizard", 
        url:"https://www.youtube.com/channel/UC4UJ26WkceqONNF5S26OiVw",
        categories: ["AI", "Youtube" ],
        description: '''
        zksvjnriol
        avnilr
        vmros
        '''
        ),
           ItemNode(
               fontColor: Colors.white,
     id: 27,
        imgUrl:"https://yt3.ggpht.com/a/AGF-l78WRSVDCTysZpO8vGdwdrvpm6z-AiXKL-I4Gw=s288-c-k-c0xffffffff-no-rj-mo", 
        name:"3Blue1Brown", 
        url:"https://www.youtube.com/channel/UCYO_jab_esuFRV4b17AJtAw",
        categories: ["Math", "Youtube" ],
        description: '''
        zksvjnriol
        avnilr
        vmros
        '''
        ),
     ItemNode(
               fontColor: Colors.white,
     id: 27,
        imgUrl:"https://yt3.ggpht.com/a/AGF-l7_2ix6FDwgjIuaOWCLjNY4jLoiKpRzRrHrqSQ=s288-c-k-c0xffffffff-no-rj-mo", 
        name:"Ben Eater", 
        url:"https://www.youtube.com/channel/UCS0N5baNlQWJCUrhCEo8WlA",
        categories: ["Computers", "Youtube" ],
        description: '''
        zksvjnriol
        avnilr
        vmros
        '''
        ),
         ItemNode(
               fontColor: Colors.white,
     id: 28,
        imgUrl:"https://yt3.ggpht.com/a/AGF-l794YutLAIBViPU2AeZCfNBRzzDjeC7FVX96Rw=s288-c-k-c0xffffffff-no-rj-mo", 
        name:"Physics Girl", 
        url:"https://www.youtube.com/channel/UC7DdEm33SyaTDtWYGO2CwdA",
        categories: ["Math", "Youtube" ],
        description: '''
        zksvjnriol
        avnilr
        vmros
        '''
        ),
      ItemNode(
        fontColor: Colors.white,
        id: 28,
        imgUrl:"https://yt3.ggpht.com/a/AGF-l7-pua7Fy8XOjLK1YFSfB_HH0q0C28S5ZBlrXg=s288-c-k-c0xffffffff-no-rj-mo", 
        name:"Eddie Woo", 
        url:"https://www.youtube.com/channel/UCq0EGvLTyy-LLT1oUSO_0FQ",
        categories: ["Math", "Youtube" ],
        description: '''
        zksvjnriol
        avnilr
        vmros
        '''
        ),

          ItemNode(
        fontColor: Colors.white,
        id: 29,
        imgUrl:"https://yt3.ggpht.com/a/AGF-l79_o6QngIpSSvxjU7AnZu86z3_7OzCy-wn2Bw=s288-c-k-c0xffffffff-no-rj-mo", 
        name:"Kurzgesagt – In a Nutshell", 
        url:"https://www.youtube.com/channel/UCsXVk37bltHxD1rDPwtNM8Q",
        categories: ["General", "Youtube" ],
        description: '''
        zksvjnriol
        avnilr
        vmros
        '''
        ),
      ItemNode(
        fontColor: Colors.white,
        id: 30,
        imgUrl:"https://yt3.ggpht.com/a/AGF-l79wQuzSpaou1Pd5O7Cfj9rU2rkzcg0XWSaATw=s288-c-k-c0xffffffff-no-rj-mo", 
        name:"Samurai Guitarist", 
        url:"https://www.youtube.com/channel/UCj1Jtb8xLUzFAm8J-Q1e1MQ",
        categories: ["Music", "Youtube" ],
        description: '''
        zksvjnriol
        avnilr
        vmros
        '''
        ),
        ItemNode(
        fontColor: Colors.white,
        id: 31,
        imgUrl:"https://yt3.ggpht.com/a/AGF-l7-R3Tc4G_czapy8OYUHlTgphrotACM6n-Vqxg=s288-c-k-c0xffffffff-no-rj-mo", 
        name:"Andrew Huang", 
        url:"https://www.youtube.com/channel/UCdcemy56JtVTrsFIOoqvV8g",
        categories: ["Music", "Youtube" ],
        description: '''
        zksvjnriol
        avnilr
        vmros
        '''
        ),



];