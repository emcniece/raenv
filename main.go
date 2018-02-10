// Copyright © 2018 NAME HERE <EMAIL ADDRESS>
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package main

//import "raenv/app/cmd"
import (
  "fmt"
  "os"

  homedir "github.com/mitchellh/go-homedir"
  "raenv/app/cmd"
)

func main() {
  configName := ".raenv"
  home, err := homedir.Dir()
  if err != nil {
    fmt.Println(err)
    os.Exit(1)
  }

  ensureConfigFileExists(home + "/" + configName)
	cmd.Execute()
}

func ensureConfigFileExists(configPath string) error {
  configFile, err := os.OpenFile(configPath, os.O_WRONLY, os.ModePerm)
  if os.IsNotExist(err) {
    configFile, err = os.Create(configPath)
    if err != nil {
      return fmt.Errorf("Couldn't create the config file: %v", err)
    } else {
      fmt.Println("Created config file", configPath)
    }
    err = nil
  }

  if err != nil {
    return fmt.Errorf("Couldn't open the config file: %v", err)
  }

  defer configFile.Close()
  return nil
}