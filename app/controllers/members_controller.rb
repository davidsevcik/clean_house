# encoding: utf-8
class MembersController < ApplicationController
  before_filter :login_required
  respond_to :html, :json

  def index
    @members = Member.of_place(current_place).order(:name)
    @members = @members.in_scope(params[:scope]) if params[:scope]
    respond_with @members
  end


  def new
    @member = Member.of_place(current_place).new
  end


  def edit
    @member = Member.of_place(current_place).find(params[:id])
  end


  def create
    @member = Member.of_place(current_place).new(params[:member])

    if @member.of_place(current_place).save
      redirect_to members_url, notice: "Člen #{@member.of_place(current_place).name} přidán."
    else
      render action: "new"
    end
  end


  def update
    @member = Member.of_place(current_place).find(params[:id])

    if @member.of_place(current_place).update_attributes(params[:member])
      redirect_to members_url, notice: "Člen #{@member.of_place(current_place).name} upraven."
    else
      render action: "edit"
    end
  end


  def destroy
    @member = Member.of_place(current_place).find(params[:id])
    @member.of_place(current_place).destroy

    redirect_to members_url, notice: "Člen #{@member.of_place(current_place).name} smazán."
  end
end
