# SwiftLeaugeAPI
A RESTful Swift library to access the Riot Games API. Use this as a starting point if you plan on using Riot Games API using Swift!

I made this basic library for an IOS application that shows you your recent games.

Only a few methods were utilized here, but if you need more, take a look at Riot's full documentation.

Paste your own key in the APIConnection's key variable.

To show you how I populate my own game class here is some sample code:

        //get our summoner id for future api calls
        var connection = APIConnection()
        let summonerId = connection.summonerIdByName(self.summonerNameTitle.stringValue)
        
        //get our recent games
        var jsonResult = connection.recentGames(summonerId)
        
        //var summonerId : Int = jsonResult["summonerId"] as! Int
        let games = jsonResult["games"] as! NSArray
        
        //create GameDoc objects from our GameData List
        for (index,game) in enumerate(games) {
            //get champion static data
            var champId: String = games[index]["championId"]!!.stringValue
            jsonResult = connection.championData(champId)
            
            let champName: String = jsonResult["key"]! as! String
            //you can find this image in your game files!
            var champImage: String = champName + "_Square_0"

            //add game to our list
            let tmpGame = GameDoc(game:games[index] as! NSDictionary,summonerId:summonerId,region:"na",
                champImage:NSImage(named: champImage))
            Games.append(tmpGame)
        }

