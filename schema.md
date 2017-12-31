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
				keywords: [ <keyword: str>: <score: int> ]
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
			taskname: <task_name: str>
			summary: <task_summary: str>
			priority: <priority: int>
			description: <task_description: str>
			team: <GUID: str>
			state: <state: str of {'open', 'pending', 'in_progress', 'closed'}
			
			ai/
				keywords: [<keyword: str>: <score: int> ]
			
			assigned: [ <auto_id>: <UUID: str> ]	
			
```
