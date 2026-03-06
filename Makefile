
all:
	docker compose -f ./srcs/docker-compose.yml up --build

down:
	docker compose -f ./srcs/docker-compose.yml down

clean: down
	docker system prune -a

fclean: clean
	docker volume prune -f
	docker network prune -f

re: fclean all

.PHONY: all down clean fclean re

