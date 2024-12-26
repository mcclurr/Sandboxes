package utils

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type Config struct {
	NWorkers          int
	WorkerIPAddrPorts []string
	InputFiles        []string
	OutputDir         string
	NOutputFiles      int
	MapKilobytes      int
	UserID            string
}

func ReadConfig(filePath string) (Config, error) {
	file, err := os.Open(filePath)
	if err != nil {
		return Config{}, fmt.Errorf("failed to open config file: %w", err)
	}
	defer file.Close()

	config := Config{}
	scanner := bufio.NewScanner(file)

	for scanner.Scan() {
		line := scanner.Text()
		if strings.TrimSpace(line) == "" || strings.HasPrefix(line, "#") {
			// Skip empty lines or comments
			continue
		}

		parts := strings.SplitN(line, "=", 2)
		if len(parts) != 2 {
			return Config{}, fmt.Errorf("invalid config line: %s", line)
		}

		key := strings.TrimSpace(parts[0])
		value := strings.TrimSpace(parts[1])

		switch key {
		case "n_workers":
			config.NWorkers, err = strconv.Atoi(value)
			if err != nil {
				return Config{}, fmt.Errorf("invalid value for n_workers: %s", value)
			}
		case "worker_ipaddr_ports":
			config.WorkerIPAddrPorts = strings.Split(value, ",")
		case "input_files":
			config.InputFiles = strings.Split(value, ",")
		case "output_dir":
			config.OutputDir = value
		case "n_output_files":
			config.NOutputFiles, err = strconv.Atoi(value)
			if err != nil {
				return Config{}, fmt.Errorf("invalid value for n_output_files: %s", value)
			}
		case "map_kilobytes":
			config.MapKilobytes, err = strconv.Atoi(value)
			if err != nil {
				return Config{}, fmt.Errorf("invalid value for map_kilobytes: %s", value)
			}
		case "user_id":
			config.UserID = value
		default:
			return Config{}, fmt.Errorf("unknown config key: %s", key)
		}
	}

	if err := scanner.Err(); err != nil {
		return Config{}, fmt.Errorf("error reading config file: %w", err)
	}

	return config, nil
}
