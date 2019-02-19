module.exports = {
    PORT : process.env.PORT || 3000,
    REGION : process.env.AWS_REGION || 'eu-west-2',
    TABLE : process.env.TABLE_NAME || 'movies'
}