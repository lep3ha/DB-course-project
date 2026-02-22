from flask import Blueprint, render_template, request, flash
from app.data.forms import CatalogFilterForm, SuppliersFilterForm, InvoicesFilterForm
from app.data.model import FetchModel
from app.auth.access import login_required

data = Blueprint("data", __name__, template_folder="templates")
fetch_model = FetchModel()

@data.route("/", methods=["GET"])
@login_required
def index():
    return render_template("monitoring.html", title="Мониторинг данных")

@data.route("/catalog", methods=["GET", "POST"])
@login_required
def catalog():
    form = CatalogFilterForm()
    items = []
    columns = []
    
    # Получаем доступные материалы для выпадающего списка
    materials_result = fetch_model.get_materials()
    if materials_result['status']:
        form.material.choices = [("", "Все")] + [(m['material'], m['material']) 
                                                for m in materials_result['data']]
    
    if request.method == "POST":
        # Собираем параметры фильтрации
        params = {
            "material": form.material.data or "",
            "min_price": float(form.min_price.data) if form.min_price.data else 0,
            "max_price": float(form.max_price.data) if form.max_price.data else 0,
            "sort_by": form.sort_by.data or "name_asc"
        }
        
        # Получаем товары с фильтрацией
        result = fetch_model.get_products(params)
        
        if result['status']:
            items = result['data']
            if items:
                columns = list(items[0].keys())  # Получаем названия колонок из первого элемента
    
    return render_template("catalog.html", 
                         form=form, 
                         items=items, 
                         columns=columns,
                         title="Каталог заготовок")


@data.route("/suppliers", methods=["GET", "POST"])
def suppliers():
    form = SuppliersFilterForm()    
    suppliers = []
    columns = []
    
    # Заполняем список городов
    cities_result = fetch_model.get_cities()
    if cities_result['status']:
        cities = [("", "Все")] + [(city['city'], city['city']) for city in cities_result['data']]
        form.city.choices = cities
    
    # Применяем фильтры
    if request.method == "POST":
        filter_params = {
            'city': form.city.data or "",
            'min_contract_date': form.min_contract_date.data,
            'max_contract_date': form.max_contract_date.data,
            'sort_by': form.sort_by.data or "name_asc"
        }
    
        result = fetch_model.get_suppliers(filter_params)
        if result['status']:
            suppliers = result['data']
            if suppliers:
                columns = list(suppliers[0].keys()) 
    
    return render_template('suppliers.html',
                         form=form,
                         suppliers=suppliers,
                         columns=columns)

@data.route("/invoices", methods=["GET", "POST"])
def invoices():
    form = InvoicesFilterForm()
    invoices = []
    columns = []
    
    # Заполняем список поставщиков
    suppliers_result = fetch_model.get_suppliers_list()
    if suppliers_result['status']:
        form.supplier_id.choices = suppliers_result['data']
    

    if request.method == "POST":
        filter_params = {
            'supplier_id': form.supplier_id.data,
            'min_delivery_date': form.min_delivery_date.data,
            'max_delivery_date': form.max_delivery_date.data,
            'min_total_cost': float(form.min_total_cost.data) if form.min_total_cost.data else 0,
            'max_total_cost': float(form.max_total_cost.data) if form.max_total_cost.data else 0,
            'sort_by': form.sort_by.data
        }
    
        result = fetch_model.get_invoices(filter_params)
        if result['status']:
            invoices = result['data']
            if invoices:
                columns = list(invoices[0].keys())
    
    return render_template('invoices.html',
                         form=form,
                         invoices=invoices,
                         columns=columns)