class MenusController < ApplicationController
  before_action :set_menu, only: [:show, :edit, :update, :destroy]

  # GET /menus
  # GET /menus.json
  def index
	  @acesso=acesso(nil)
    @menus = Menu.all.page(params['page']).per(10)
  end

  # GET /menus/1
  # GET /menus/1.json
  def show
	  @acesso=acesso(nil)
  end

  # GET /menus/new
  def new
	  @acesso=acesso(nil)
    @menu = Menu.new
	  @menus = @menu.menusPorNivel(">",session[:usuario_id])
  end

  # GET /menus/1/edit
  def edit
  	@acesso=acesso(nil)
  	@menus = @menu.menusPorNivel(">",session[:usuario_id])
  end

  # POST /menus
  # POST /menus.json
  def create
	  @acesso=acesso(nil)
    @menu = Menu.new(menu_params)
    @menus = @menu.menusPorNivel(">",session[:usuario_id])
    respond_to do |format|
      if @menu.save
        _menu_id=Menu.new.ultimo.try(:id)
        _sistema_id=Sistema.where(Nome:"Menu").first.try(:id)
        Perfil.new.adiciona_politica_por_menu_para_perfis_de_usuario(session[:usuario_id],_menu_id,_sistema_id)
        format.html { redirect_to @menu, notice: 'Menu was successfully created.' }
        format.json { render :show, status: :created, location: @menu }
      else
        format.html { render :new }
        format.json { render json: @menu.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /menus/1
  # PATCH/PUT /menus/1.json
  def update
    @acesso=acesso(nil)
    respond_to do |format|
      if @menu.update(menu_params)
		_menu_id=Menu.new.ultimo.try(:id)
		_sistema_id=Sistema.where(Nome:"Menu").first.try(:id)
		Perfil.new.adiciona_politica_por_menu_para_perfis_de_usuario(session[:usuario_id],_menu_id,_sistema_id)
        format.html { redirect_to @menu, notice: 'Menu was successfully updated.' }
        format.json { render :show, status: :ok, location: @menu }
      else
        format.html { render :edit }
        format.json { render json: @menu.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /menus/1
  # DELETE /menus/1.json
  def destroy
	@acesso=acesso(nil)
	@menu = Menu.find(params[:id])
	@menu.destroy
	respond_to do |format|
		if @menu.try(:errors).try(:messages).nil?
			format.html { redirect_to menus_url, notice: 'Menu was successfully destroyed.' }
			format.json { head :no_content }
		else
			format.html { render :show }
			format.json { render json: @menu.errors, status: :unprocessable_entity }
		end
	end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_menu
      @menu = Menu.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def menu_params
      params.require(:menu).permit(:nome, :link, :pai_id)
    end
end
