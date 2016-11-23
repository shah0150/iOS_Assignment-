//
//  TableController.swift
//  uitableview_load_data_from_json_swift_3
//

import UIKit

class TableController: UITableViewController {

    var TableData:Array< String > = Array < String >()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        get_data_from_url("https://planets-hurdleg.mybluemix.net/planets")
    }



    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableData.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = TableData[indexPath.row]
        
        return cell
    }
  

    
    
    
    
    func get_data_from_url(_ link:String)
    {
        let url:URL = URL(string: link)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        

        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (
            data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                
               return
            }
            
            
            self.extract_json(data!)

            
        }) 
        
        task.resume()
        
    }

    
    func extract_json(_ data: Data)
    {
        
        
        let json: Any?
        
        do
        {
            json = try JSONSerialization.jsonObject(with: data, options: [])
        }
        catch
        {
            return
        }
        
        guard let data_list = json as? NSArray else
        {
            return
        }
        
        
        if let json_list = json as? NSArray
        {
            for i in 0 ..< data_list.count
            {
                if let country_obj = json_list[i] as? NSDictionary
                {
                    if let json_name = country_obj["name"] as? String
                    {
                        if let json_email = country_obj["overview"] as? String
                        {
                            TableData.append(json_name + " [" + json_email + "]")
                        }
                    }
                }
            }
        }
        
        
        
        DispatchQueue.main.async(execute: {self.do_table_refresh()})

    }

    func do_table_refresh()
    {
        self.tableView.reloadData()
        
    }
    

}
