# Sarto's EDOPro Custom Cards

To install these cards, open your `configs/configs.json`file in the game's folder, then paste the following lines in the following places:

* [Adding the cards](#Adding the cards)
* [Adding the images](#Adding the images)
* [Connecting to the server](#Connecting to the server)

### Adding the cards

First, copy these lines of code:

```json
,
		{
			"url": "https://github.com/SartoRiccardo/sarto-edopro",
			"repo_name": "Sarto Custom",
			"repo_path": "./expansions",
			"should_update": true,
			"should_read": true
		}
```

And paste them here:

```json
...
      "should_update": true,
			"should_read": true
		},
		{
			"url": "https://github.com/ProjectIgnis/Puzzles",
			"repo_name": "Project Ignis puzzles",
			"repo_path": "./puzzles/Canon collection",
			"should_update": true,
			"should_read": true
		} ←←←
	],
	"urls": [
...
```

So you should have:

```json
...
      "should_update": true,
			"should_read": true
		},
		{
			"url": "https://github.com/ProjectIgnis/Puzzles",
			"repo_name": "Project Ignis puzzles",
			"repo_path": "./puzzles/Canon collection",
			"should_update": true,
			"should_read": true
		},
		{
			"url": "https://github.com/SartoRiccardo/sarto-edopro",
			"repo_name": "Sarto Custom",
			"repo_path": "./expansions",
			"should_update": true,
			"should_read": true
		}
	],
	"urls": [
...
```

### Adding the images

First, copy these lines of code:

```json
,
		{
			"url": "https://www.riccardosartori.it/api/img/edopro/{}.jpg",
			"type": "pic"
		}
```

And paste them here:

```json
...
		},
		{
			"url": "default",
			"type": "cover"
		} ←←←
	],
	"servers": [
		{
...
```

So you should have:

```json
...
		},
		{
			"url": "default",
			"type": "cover"
		},
		{
			"url": "https://www.riccardosartori.it/api/img/edopro/{}.jpg",
			"type": "pic"
		}
	],
	"servers": [
		{
...
```

### Connecting to the server

If you want to play on my own server, first, copy these lines of code:

```json
,
		{
			"name": "Sarto Custom",
			"address": "<server-address>",
			"duelport": 7913,
			"roomaddress": "<server-address>",
			"roomlistport": 7924
		}
```

And paste them here:

```json
...
		{
			"name": "US West (Competitive)",
			"address": "us.ygopro.co",
			"duelport": 7912,
			"roomaddress": "us.ygopro.co",
			"roomlistport": 7923
		} ←←←
	],
	"posixPathExtension": "/usr/local/bin:/Library/Frameworks/Mono.framework/Versions/Current/Commands"
}
...
```

So you should have:

```json
...
		{
			"name": "US West (Competitive)",
			"address": "us.ygopro.co",
			"duelport": 7912,
			"roomaddress": "us.ygopro.co",
			"roomlistport": 7923
		},
		{
			"name": "Sarto Custom Card Server",
			"address": "<server-address>",
			"duelport": 7913,
			"roomaddress": "<server-address>",
			"roomlistport": 7924
		}
	],
	"posixPathExtension": "/usr/local/bin:/Library/Frameworks/Mono.framework/Versions/Current/Commands"
}
...
```

Contact me for the `<server-address>`, I suppose.

