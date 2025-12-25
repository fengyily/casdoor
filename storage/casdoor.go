package storage

import (
	"github.com/casdoor/oss"
	"github.com/casdoor/oss/casdoor"
)

func NewCasdoorStorageProvider(providerType string, clientId string, clientSecret string, region string, bucket string, endpoint string, cert string, content string) oss.StorageInterface {
	sp := casdoor.New(&casdoor.Config{
		ClientId:     clientId,
		ClientSecret: clientSecret,
		Endpoint:     endpoint,
		Certificate:  cert,
		Region:       region,
		Content:      content,
		Bucket:       bucket,
	})
	return sp
}
