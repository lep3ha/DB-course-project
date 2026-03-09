from flask_wtf import FlaskForm
from wtforms import HiddenField, IntegerField, SubmitField
from wtforms.validators import DataRequired, NumberRange


class AddToCartForm(FlaskForm):
    workpiece_id = HiddenField('workpiece_id', validators=[DataRequired()])
    price_at_add = HiddenField('price_at_add', validators=[DataRequired()])
    quantity = IntegerField('quantity', default=1, validators=[DataRequired(), NumberRange(min=1)])
    submit = SubmitField('Добавить в корзину')


class UpdateCartItemForm(FlaskForm):
    item_id = HiddenField('item_id', validators=[DataRequired()])
    quantity = IntegerField('quantity', validators=[DataRequired(), NumberRange(min=1)])
    submit = SubmitField('Обновить')
