//
//  SystemConfig.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-8-31.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "SystemConfig.h"

@implementation SystemConfig

@synthesize ID;
@synthesize typeId;
@synthesize name;
@synthesize emailNotifi;
@synthesize noticeNotifi;
@synthesize calendarNotifi;

+ (void)synchronizeSystemConfig {
    [self deleteSystemConfig];


}

+ (NSMutableArray *)loadSystemConfigById:(NSString *) sender {
    NSMutableArray *dataList = [[NSMutableArray alloc] initWithCapacity:20];
    NSString *webserviceUrl = [[NSUtil chooseRealm] stringByAppendingString:@"Setting.asmx/getWorkTypeByEmpId"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSLog(@"%@", url);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request setPostValue:sender forKey:@"EmpId"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
    
    // NSLog(@"%@", [request responseString]);
    if(request.responseStatusCode == 200)
    {
        NSData *responseData = [request responseData];
        dataList = [SystemConfig loadSystemConfig:responseData withSync:NO];
    } else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法访问，请检查网络连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
    }
    return dataList;
}

+ (NSMutableArray *) loadSystemConfig:(NSData *) responseData withSync:(BOOL) flag {
    NSMutableArray *dataList = [[NSMutableArray alloc] initWithCapacity:20];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseData options:0 error:&error];
    if (doc == nil) { return nil; }
    NSArray *systemConfigMembers = [doc.rootElement elementsForName:@"ModJsonSetting"];
    for (GDataXMLElement *systemConfigMember in systemConfigMembers) {
        SystemConfig *systemConfig = [[SystemConfig alloc] init];
        
        //ID
        NSArray *ids = [systemConfigMember elementsForName:@"ID"];
        if (ids.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [ids objectAtIndex:0];
            systemConfig.ID = firstId.stringValue;
        } else {
            systemConfig.ID = @"";
        }
        
        //typeId
        NSArray *typeIds = [systemConfigMember elementsForName:@"typeId"];
        if (typeIds.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [typeIds objectAtIndex:0];
            systemConfig.typeId = firstId.stringValue;
        } else {
            systemConfig.typeId = @"";
        }
        
        //name
        NSArray *names = [systemConfigMember elementsForName:@"name"];
        if (names.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [names objectAtIndex:0];
            systemConfig.name = firstId.stringValue;
        } else {
            systemConfig.name = @"";
        }
        
        [dataList addObject:systemConfig];
    }

    return dataList;
}
    

+ (void)insertSystemConfig:(SystemConfig *) systemConfig {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &hzoaDB)==SQLITE_OK) {
        NSString *ID = systemConfig.ID;
        NSString *typeId = systemConfig.typeId;
        NSString *name = systemConfig.name;
        
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO SYSTEMCONFIG VALUES(\"%@\",\"%@\",\"%@\")", ID, typeId, name];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(hzoaDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
        } else {
            NSLog(@"保存失败");
        }
        sqlite3_finalize(statement);
        sqlite3_close(hzoaDB);
    }

}

+ (void)deleteSystemConfig {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *stmt = nil;
    if (sqlite3_open(dbpath, &hzoaDB) == SQLITE_OK) 
    {
        const char *query = "DELETE FROM SYSTEMCONFIG;";
        if (sqlite3_prepare_v2(hzoaDB, query, -1, &stmt, NULL) != SQLITE_OK) {
            NSLog(@"delete data failed!");
        }
        if (sqlite3_step(stmt) != SQLITE_DONE) {
            NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(hzoaDB));
        }
    } else {
        NSLog(@"创建/打开数据库失败");
    }
}

+ (void)createSystemConfigTable {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &hzoaDB)==SQLITE_OK) 
    {
        char *errMsg;
        const char *sql_stmt = "CREATE TABLE IF NOT EXISTS SYSTEMCONFIG(ID VARCHAR(20) PRIMARY KEY, TYPEID VARCHAR(20), NAME TEXT);";
        if (sqlite3_exec(hzoaDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK) {
            NSLog(@"create failed!\n");
        }
    }
    else 
    {
        NSLog(@"创建/打开数据库失败");
    }
}

+ (void)createNotificationTable {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &hzoaDB)==SQLITE_OK) 
    {
        char *errMsg;
        const char *sql_stmt = "CREATE TABLE IF NOT EXISTS NOTIFICATIONINFO(ID VARCHAR(20) PRIMARY KEY, EMAIL_NOTIFICATION VARCHAR(2), NOTICE_NOTIFICATION VARCHAR(2), CALENDAR_NOTIFICATION VARCHAR(2));";
        if (sqlite3_exec(hzoaDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK) {
            NSLog(@"create failed!\n");
        }
    }
    else 
    {
        NSLog(@"创建/打开数据库失败");
    }
}

+ (void)insertNotification:(SystemConfig *) systemConfig {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &hzoaDB)==SQLITE_OK) {
        NSString *ID = systemConfig.ID;
        NSString *email = systemConfig.emailNotifi;
        NSString *notice = systemConfig.noticeNotifi;
        NSString *calendar = systemConfig.calendarNotifi;
        
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO NOTIFICATIONINFO VALUES(\"%@\",\"%@\",\"%@\",\"%@\")", ID, email, notice, calendar];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(hzoaDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
        } else {
            NSLog(@"保存失败");
        }
        sqlite3_finalize(statement);
        sqlite3_close(hzoaDB);
    }
    
}

+ (void)updateNotification:(SystemConfig *) systemConfig {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &hzoaDB)==SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE NOTIFICATIONINFO SET EMAIL_NOTIFICATION = \"%@\", NOTICE_NOTIFICATION = \"%@\", CALENDAR_NOTIFICATION = \"%@\" WHERE ID = \"%@\";", systemConfig.emailNotifi, systemConfig.noticeNotifi, systemConfig.calendarNotifi, systemConfig.ID];
        const char *insert_stmt = [querySQL UTF8String];
        sqlite3_prepare_v2(hzoaDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
        } else {
            NSLog(@"更新失败");
        }
        sqlite3_finalize(statement);
        sqlite3_close(hzoaDB);
    }
}

+ (void)dropSystemConfigTable {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *stmt = nil;
    if (sqlite3_open(dbpath, &hzoaDB) == SQLITE_OK) 
    {
        NSString *dropSql = @"DROP TABLE IF EXISTS NOTIFICATIONINFO;";
        const char *query = [dropSql UTF8String];
        if (sqlite3_prepare_v2(hzoaDB, query, -1, &stmt, NULL) != SQLITE_OK) {
            NSLog(@"drop table failed!");
        }
        if (sqlite3_step(stmt) != SQLITE_DONE) {
            NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(hzoaDB));
        }
    }
    else 
    {
        NSLog(@"创建/打开数据库失败");
    }
}

+ (NSString *) getVersion {
    NSString *webserviceUrl = [[NSUtil chooseRealm] stringByAppendingString:@"Setting.asmx/GetHighestAppVersion"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSLog(@"%@", url);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request setPostValue:@"iPad" forKey:@"AppType"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
    NSString *retStr = @"";
    if(request.responseStatusCode == 200)
    {
        NSError *error;
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:[request responseString] options:0 error:&error];
        GDataXMLElement *root = [doc rootElement];
        retStr = [root stringValue];
    } else {
        
    }
   
    return retStr;
    
}

+ (NSMutableArray *) getNoticeType:(NSString *) employeeId {
    NSMutableArray *dataList = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *webserviceUrl = [[NSUtil chooseRealm] stringByAppendingString:@"Notice.asmx/GetNoticeSendType"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSLog(@"%@", url);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request setPostValue:employeeId forKey:@"empId"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
    if(request.responseStatusCode == 200)
    {
        NSError *error;
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:[request responseString] options:0 error:&error];
        GDataXMLElement *root = [doc rootElement];
        NSData *data = [[root stringValue] dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &error];
        if (!jsonArray) {
            NSLog(@"Error parsing JSON: %@", error);
        } else {
            for(NSDictionary *item in jsonArray) {
                SystemConfig *systemConfig = [[SystemConfig alloc] init];
                systemConfig.typeId = [item objectForKey:@"Key"];
                systemConfig.name = [item objectForKey:@"Value"];
                [dataList addObject:systemConfig];
            }
        }
    }
    return dataList;
}

@end
