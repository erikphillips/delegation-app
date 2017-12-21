# Database Schema #

The database is held in a Firebase format:

```
delegation-app/
	users/
		<UID>/
			access/
				<team_id>: <access_level: str of {'owner', 'admin', 'manager', 'member'}>
				
			information/
				firstname: <first_name: str>
				lastname: <last_name: str>
				email: <email_address: str>
				phone: <phone_number: str>
			
			teams: [ <GID>: <team_name: str> ]
			
			ai/
				keywords: [ <keyword: str>: <score: int> ]
				preferences: ...
				muted_topics: ...
			
			current_tasks: [ <task_id>: <task_name> ]
			closed_tasks: [ <task_id>: <task_name> ]
			
	teams/  (i.e. group)
		<GID>/
			teamname: <team_name: str>
			description: <description: str>
			owner: <UID: str>
			members: [ <UID>: <full_name> ]
			tasks: [ <task_id>: <task_name> ]
			
			access/
				<UID of str>: <access_level: str of {'owner', 'admin', 'manager', 'member'}>
				
	tasks/
		<TID>/
			taskname: <task_name: str>
			summary: <task_summary: str>
			priority: <priority: int>
			description: <task_description: str>
			team: <team_id>
			state: <state: str of {'open', 'pending', 'in_progress', 'closed'}
			
			ai/
				keywords: [<keyword: str>: <score: int> ]
			
			assigned: [ <UID>: <full_name: str> ]	
			
```
