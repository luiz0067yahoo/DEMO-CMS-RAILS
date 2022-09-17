require 'test_helper'

class NoticiaFotosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @noticia_foto = noticia_fotos(:one)
  end

  test "should get index" do
    get noticia_fotos_url
    assert_response :success
  end

  test "should get new" do
    get new_noticia_foto_url
    assert_response :success
  end

  test "should create noticia_foto" do
    assert_difference('NoticiaFoto.count') do
      post noticia_fotos_url, params: { noticia_foto: { Noticia_id: @noticia_foto.Noticia_id, descricao: @noticia_foto.descricao, nome: @noticia_foto.nome } }
    end

    assert_redirected_to noticia_foto_url(NoticiaFoto.last)
  end

  test "should show noticia_foto" do
    get noticia_foto_url(@noticia_foto)
    assert_response :success
  end

  test "should get edit" do
    get edit_noticia_foto_url(@noticia_foto)
    assert_response :success
  end

  test "should update noticia_foto" do
    patch noticia_foto_url(@noticia_foto), params: { noticia_foto: { Noticia_id: @noticia_foto.Noticia_id, descricao: @noticia_foto.descricao, nome: @noticia_foto.nome } }
    assert_redirected_to noticia_foto_url(@noticia_foto)
  end

  test "should destroy noticia_foto" do
    assert_difference('NoticiaFoto.count', -1) do
      delete noticia_foto_url(@noticia_foto)
    end

    assert_redirected_to noticia_fotos_url
  end
end
