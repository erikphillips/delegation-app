# Database Schema #

The database is held in a Firebase format (JSON):

```
delegation-app/
	users/
		<UUID>/	
			information/
				firstname: <first_name: str>
				lastname: <last_name: str>
				email: <email_address: str>
				phone: <phone_number: str>
				
				notify
			
			teams: [ <auto_id>: <GUID: str> ]
			
			ai/
				keywords: [ <keyword: str>: <score: int> ] -> [0,10)
				preferences: ...
				muted_topics: ...
			
			current_tasks: [ <auto_id>: <TUID: str> ]
			closed_tasks: [ <auto_id>: <TUID: str> ]
			
	teams/  (i.e. group)
		<GUID>/
			information/
				teamname: <team_name: str>
				description: <description: str>
				owner: <UUID: str>
			members: [ <auto_id>: <UUID: str> ]
			tasks: [ <auto_id>: <TUID: str> ]
			
			access/
				<UUID>: <access_level: str of {'owner', 'admin', 'manager', 'member'}>
				
	tasks/
		<TUID>/
			title: <task_name: str>
			priority: <priority: int>
			description: <task_description: str>
			team: <GUID: str>
			status: <status: str of {'open', 'assigned', 'in_progress', 'closed'}
			resolution: <resolution: str of {'none', 'duplicate', 'fixed'}
			duplicate: <TUID: str optional>  (i.e. the id of the duplicate task)
			assignee: <UUID: str>
			
			ai/
				keywords: [<keyword: str>: <score: int>] -> [0,10)
			
```
