defmodule Din.Resources.Emoji do
  alias Din.Error

  @doc """
  Returns a list of emoji objects for the given guild.
  """
  @spec list_guild_emojis(Din.snowflake) :: list(map) | Error.t
  def list_guild_emojis(guild_id) do
    Din.API.get "/guilds/#{guild_id}/emojis"
  end

  @doc """
  Returns an emoji object for the given guild and emoji IDs.
  """
  @spec get_guild_emoji(Din.snowflake, Din.snowflake) :: map | Error.t
  def get_guild_emoji(guild_id, emoji_id) do
    Din.API.get "/guilds/#{guild_id}/emojis/#{emoji_id}"
  end

  @doc """
  Create a new emoji for the guild.

  Returns the new emoji object on success. Fires a Guild Emojis Update Gateway event.

  > Passing the roles field will be ignored unless the application is whitelisted as an emoji provider. For more information and to request whitelisting please contact support@discordapp.com.

  ## Parameters

  - `name` - name of the emoji
  - `image` - the 128x128 emoji image path
  - `roles` - roles for which this emoji will be whitelisted
  """
  @spec create_guild_emoji(Din.snowflake, [
    name: String.t,
    image: String.t,
    roles: list(Din.snowflake)
  ]) :: map | Error.t
  def create_guild_emoji(guild_id, opts \\ []) do
    opts = case opts[:image] do
      nil -> opts
      img -> Keyword.put opts, :image, Din.Util.build_base64_image_data(img)
    end
    
    Din.API.post "/guilds/#{guild_id}/emojis", opts
  end

  @doc """
  Modify the given emoji.

  Returns the updated emoji object on success. Fires a Guild Emojis Update Gateway event.

  > Passing the roles field will be ignored unless the application is whitelisted as an emoji provider. For more information and to request whitelisting please contact support@discordapp.com

  ## Parameters

  - `name` - name of the emoji
  - `roles` - roles for which this emoji will be whitelisted
  """
  @spec modify_guild_emoji(Din.snowflake, Din.snowflake, [
    name: String.t,
    roles: list(Din.snowflake)
  ]) :: map | Error.t
  def modify_guild_emoji(guild_id, emoji_id, opts \\ []) do
    Din.API.patch "/guilds/#{guild_id}/emojis/#{emoji_id}", opts
  end

  @doc """
  Delete the given emoji.

  Returns `:ok` on success. Fires a Guild Emojis Update Gateway event.
  """
  @spec delete_guild_emoji(Din.snowflake, Din.snowflake) :: :ok | Error.t
  def delete_guild_emoji(guild_id, emoji_id) do
    Din.API.patch "/guilds/#{guild_id}/emojis/#{emoji_id}"
  end
end
