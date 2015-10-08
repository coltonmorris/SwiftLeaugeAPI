//
//  LeagueAPI.swift
//  LeagueOfLegends
//
//  Created by Colton Morris on 9/28/15.
//
//

import Foundation

class APIConnection {
    var endpoint: String = "https://na.api.pvp.net"
    var key: String = "api_key="
    
    func championData(championId: String) -> NSDictionary{
    // ChampionId is a string for simplicity.
    // I use this function to find a champions name.
    // Another useful item is the champion key. Each champion has images in the game files, and each image
    //  uses the key to name the file.
        
        var championDataRequestFirst: String = "/api/lol/static-data/na/v1.2/champion/"
        var championDataRequestLast: String = "?champData=all&"
        
        var url: String = self.endpoint + championDataRequestFirst + championId + championDataRequestLast + self.key
        var jsonResult = synchronousRequest(url)
        
        return jsonResult
    }
    
    func recentGames(summonerId: Int) -> NSDictionary {
        //recent games must have the summoner ID in between strings
        var recentGamesRequestFirst: String = "/api/lol/na/v1.3/game/by-summoner/"
        var recentGamesRequestLast: String = "/recent?"
        
        //get our json object through the api call
        var url: String = self.endpoint + recentGamesRequestFirst + String(summonerId) + recentGamesRequestLast + self.key
        var jsonResult = synchronousRequest(url)
        
        //if there are no games, return an empty dictionary
        if jsonResult.count == 0 {
            println("No games exist for the summoner")
            return NSDictionary()
        }
        return jsonResult
    }
    
    func summonerIdByName (summonerName: String) -> Int {
        //url constants for the api method
        var summonerByNameFirst : String = "/api/lol/na/v1.4/summoner/by-name/"
        var summonerByNameLast : String = "?"
        
        //get our json object through the api call
        var url: String = self.endpoint + summonerByNameFirst + summonerName + summonerByNameLast + self.key
        var jsonResult = synchronousRequest(url)
        
        //check for errors, if the name wasn't valid, return a -1
        if jsonResult.count == 0 {
            println("Summoner name doesn't exist")
            return -1
        }
        
        var summonerId: Int = jsonResult[summonerName]!["id"]! as! Int
        return summonerId
    }
    
    func synchronousRequest(url_in: String) -> NSDictionary {
        //creating the request
        let url: NSURL! = NSURL(string: url_in)
        var request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var error: NSError?
        var response: NSURLResponse?
        
        let urlData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
        
        //return an empty dictionary if the status code wasn't 200
        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode != 200 {
                println("Error: \(httpResponse.statusCode)")
                return NSDictionary()
            }
        }
        
        error = nil
        let resultDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
        return resultDictionary
    }
}
