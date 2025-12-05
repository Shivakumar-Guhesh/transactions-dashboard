from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm.exc import NoResultFound

from ..dependencies import get_user_service
from ..schemas import user_schemas
from ..services.user_service import UserService

router = APIRouter(prefix="/users", tags=["Users"])


@router.post(
    "/",
    status_code=status.HTTP_201_CREATED,
    response_model=user_schemas.UserCreateResponse,
)
def create_user(
    user: user_schemas.UserCreateRequest,
    service: UserService = Depends(get_user_service),
):

    return service.create_user(
        user=user,
    )


@router.get("/{user_id}", response_model=user_schemas.UserCreateResponse)
def get_user(
    user_id: int,
    service: UserService = Depends(get_user_service),
):
    try:
        user = service.get_user_by_id(user_id)
    except NoResultFound:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"User with id: {user_id} does not exist",
        )

    return user
