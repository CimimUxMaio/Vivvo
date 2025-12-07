dev:
	@echo "Starting Phoenix server..."
	iex -S mix phx.server && echo "✔️ Phoenix server started"

setup:
	@echo "Starting Docker containers..."
	docker compose -f docker-compose-dev.yml up -d && echo "✔️ Docker containers started"
	@echo "Installing npm dependencies..."
	npm install --prefix assets && echo "✔️ npm dependencies installed"
	@echo "Clearing DB..."
	mix ecto.drop && echo "✔️ Database dropped"
	@echo "Setting up mix project..."
	mix setup && echo "✔️ mix setup complete"

stop:
	@echo "Stopping Docker containers..."
	docker compose -f docker-compose-dev.yml down && echo "✔️ Docker containers stopped"
