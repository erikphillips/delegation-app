# Database Schema #

The database is held in a Firebase format:

```
delegation-app/
	users/
		<UID>/
			information/
				firstname: <first_name: str>
				lastname: <last_name: str>
				fullname: !firstname + " " + !lastname
				email: <email_address: str>
				phone: <phone_number: str>
			groups: [ <GID>: <group_name: str> ]
			ai/
				keywords: [ <keyword: str>: <score: int> ]
			current_tasks: [ <task_id>: <task_name> ]
			
	teams/
		<GID>/
			information/
				teamname: <team_name: str>
				members: [ <UID>: <full_name> ]
			tasks: [ <task_id>: <task_name> ]
				
	tasks/
		<TID>/
			information/
				taskname: <task_name: str>
				summary: <task_summary: str>
				priority: <priority: int>
				description: <task_description: str>
				team: <team_id>
			ai/
				keywords: [<keyword: str>: <score: int> ]
			assigned: [ <UID>: <full_name: str> ]	
			
```
