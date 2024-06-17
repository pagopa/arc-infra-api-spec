{
  "openapi": "3.0.1",
  "info": {
    "title": "Example Echo API",
    "description": "An API that echoes the message 'Ciao'.",
    "version": "1.0.0"
  },
  "servers": [
    {
      "url": "https://api.example.com"
    }
  ],
  "paths": {
    "/echo": {
      "get": {
        "summary": "Echo message",
        "operationId": "echoMessage",
        "responses": {
          "200": {
            "description": "Echoed message",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "message": {
                      "type": "string",
                      "example": "Ciao"
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}